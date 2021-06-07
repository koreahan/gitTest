<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Board</title>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
		<meta name="description" content="" />
		<meta name="keywords" content="" />
		<link rel="stylesheet" href="/resources/assets/css/main.css" />
		<style>
			.uploadResult{
				width:100%;
			}
			.uploadResult ul{
				display:flex;
				justify-content:center;
			}
			
			.uploadResult ul li{
				list-style:none;
				padding:10px;
			}
		</style>
	</head>
	<body class="is-preload">
		<!-- Main -->
			<div id="main">
				<div class="wrapper">
					<div class="inner">

						<!-- Elements -->
							<header class="major">
								<h1>Board</h1>
								<p>게시글 등록</p>
							</header>
									<!-- Table -->
										<h3><a href="/board/list${cri.getListLink()}" class="button small">목록 보기</a></h3>
						<div class="content">
							<div class="form">
								<form role="form" action="/board/register" method="post" id="regForm">
									<div class="fields">
										<div class="field">
											<h4>제목</h4>
											<input name="title" placeholder="Title" type="text" />
										</div>
										<div class="field">
											<h4>내용</h4>
											<textarea name="content" rows="6" placeholder="Content" style="resize:none"></textarea>
										</div>
										<div class="field">
											<h4>작성자</h4>
											<input name="writer" placeholder="Writer" type="text" />
										</div>
										<div class="field uploadDiv">
											<h4>첨부파일</h4>
											<input type="file" name="uploadFile" multiple>
										</div>
										<div class="field">
											<div class="uploadResult">
												<ul></ul>
											</div>
										</div>
									</div>
									<ul class="actions special">
										<li><input type="submit" class="button" value="등록" /></li>
									</ul>
								</form>
							</div>
										</div>
								</div>
							</div>
						</div> 
		<!-- Scripts -->
			<script src="/resources/assets/js/jquery.min.js"></script>
			<script src="/resources/assets/js/jquery.dropotron.min.js"></script>
			<script src="/resources/assets/js/browser.min.js"></script>
			<script src="/resources/assets/js/breakpoints.min.js"></script>
			<script src="/resources/assets/js/util.js"></script>
			<script src="/resources/assets/js/main.js"></script>
	</body>
	<script>
		$(document).ready(function(){
			var uploadResult = $(".uploadResult ul");//첨부파일 이미지 썸네일, 일반 파일을 대표하는 이미지 목록이 들어갈 ul태그
			var cloneObj = $(".uploadDiv").clone();//사용자가 첨부파일을 추가한 후 리셋하기 위해 원본을 복사해 놓는다.
			var contextPath = "${pageContext.request.contextPath}";
			var regex = new RegExp("(.*/)\.(exe|sh|zip|alz)");//마침표 뒤에 모든 문자열을 검사하되 명시된 확장자일 때 test() true
			var maxSize = 1024 * 1024 * 5; //5MB
			
			//업로드한 파일의 확장자와 파일 크기를 검사해주는 함수
			function checkExtension(fileName, fileSize){
				if(regex.test(fileName)){
					alert("업로드 할 수 없는 확장자입니다.");
					return false;
				}
				
				if(fileSize >= maxSize){
					alert("파일 사이즈 초과");
					return false;
				}
				return true;//업로드 가능 파일일 때 true
			}
			
			//업로드한 첨부파일 썸네일 이미지 하단에 x버튼을 클릭하면 들어온다.
			$(".uploadResult").on("click", "span", function(e){
				var file = $(this).data("file");//파일 정보
				var type = $(this).data("type");//이미지라면 image, 일반 파일이라면 file
				var target = $(this).closest("li");//클릭한 span태그에서 가장 가까운 li태그를 찾아온다.
				$.ajax({
					url: "/deleteFile",
					data: {fileName:file , fileType:type},
					dataType: "text",
					type: "post",
					success: function(result){
						alert(result);
						//해당 경로에 업로드된 파일을 JAVA서버단에서 삭제했다면, li태그도 삭제해준다.
						target.remove();
					}
				});
			})
			
			//등록완료 버튼 클릭 시 들어온다.
			$("input[type='submit']").on("click", function(e){
				e.preventDefault();//submit 기능 소멸
				console.log("submit clicked");
				var form = $("form[role='form']");
				var str = "";
				
				//썸네일(업로드된 파일)의 개수만큼 반복
				$(".uploadResult ul li").each(function(i, obj){
				//obj는 JS이다, data()는 jQuery이기 때문에 $()로 감싸준다.
				
					//submit을 하기 전에 첨부파일의 정보도 같이 담아준다.
					str += "<input type='hidden' name='attachList[" + i +"].uploadPath' value='" + $(obj).data("path") + "'>";
					str += "<input type='hidden' name='attachList[" + i +"].uuid' value='" + $(obj).data("uuid") + "'>";
					str += "<input type='hidden' name='attachList[" + i +"].fileName' value='" + $(obj).data("filename") + "'>";
					str += "<input type='hidden' name='attachList[" + i +"].fileType' value='" + $(obj).data("type") + "'>";
				});
				//form 데이터에 첨부파일 정보를 추가한 후 submit해준다.
				form.append(str).submit();
			});
			
			//업로드에 성공한 파일 list를 전달받고, HTML에 추가해준다.
			function showUploadResult(uploadResults){
				var str = "";
				//업로드 된 파일 개수 만큼 반복한다.
				$(uploadResults).each(function(i, obj){
					//encodeURIComponent() : 서버로 특정 문자열을 전송할 때 명령어로 인식하는 문자 혹은 인식이 불가능한 문자를
					//						 코드번호로 변경시켜주는 함수
					if(!obj.fileType){//fileType은 VO에서 boolean으로 설정했기 때문에 조건식자리에 바로 사용한다.
						//일반 파일
						var filePath = encodeURIComponent(obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName);
						str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.fileType + "'>"
						str += "<div><img src='/resources/images/attach.png' width=100 height=100>";//미리 준비한 이미지로 대체
						str += "<br>" + obj.fileName;
						str += "&nbsp;&nbsp;&nbsp;<span data-file='" + filePath + "' data-type='file'>x</span></div></li>";
					}else{
						//이미지 파일
						var thumbPath = encodeURIComponent(obj.uploadPath + "\\s_" + obj.uuid + "_" + obj.fileName);
						str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.fileType + "'>"
						//img태그의 src에 byte[]을 전달받은 후 브라우저에서 랜더링을 통해 해당 이미지로 복원된다.
						str += "<div><img src='/display?fileName=" + thumbPath + "' width=100 height=100>";
						str += "<br>" + obj.fileName;
						str += "&nbsp;&nbsp;&nbsp;<span data-file='" + thumbPath + "' data-type='image'>x</span></div></li>";
					}
				});
				//썸네일 ul태그에 li태그들을 추가해준다.
				//append를 사용하는 이유는 여러 번 첨부파일 추가를 진행했을 때 이전 목록을 유지하기 위함이다.
				uploadResult.append(str);
			}
			
			//첨부파일을 추가한 순간 들어온다.
			//clone에 담아두었던 원본 input태그를 DOM으로 추가하기 때문에,
			//이벤트 위임을 통해 구현한다.
			$(".uploadDiv").on("change", "input[type='file']", function(e){
				var formData = new FormData();//form태그를 만들어준다.
				var inputFile = $("input[name='uploadFile']"); //첨부파일 정보를 가지고 있는 태그
				var files = inputFile[0].files; // 해당 태그들 중 첫번째 input태그에서 파일들을 가져온다.
				
				//업로드한 첨부파일의 개수만큼 반복한다.
				for(let i=0; i<files.length; i++){
					//유효성 검사 진행
					if(!checkExtension(files[i].name, files[i].size)){
						return false;
					}
					//정상적인 첨부파일일 경우 form에 KEY, VALUE 설정을 해준다.
					formData.append("uploadFile", files[i]);
				}
				
				$.ajax({
					url: '/uploadAjaxAction',
					processData: false,
					contentType: false,	//Default로 전송하면 충돌 혹은 오류가 발생하므로 아예 사용하질 않는다.
					data: formData,	//자동으로 contentType은 multipart로 설정된다.
					type: "post",
					dataType: "json",
					success: function(result){
						console.log(result);
						//result : 업로드 성공파일 목록, 업로드 실패파일 목록
						if(result.failureList.length != 0){//만약 실패한 파일이 있다면
							var str = "";
							for(let i=0; i<result.failureList.length; i++){
								//어떤 파일이 실패했는지를
								str += result.failureList[i].fileName + "\n";
							}
							//경고 메세지로 출력
							alert("지원하지 않는 파일의 형식은 제외되었습니다.\n" + str);
						}
						
						//썸네일 실행
						showUploadResult(result.succeedList);//업로드 성공된 파일들만 전달해준다.
						$(".uploadDiv").html(cloneObj.html());//기존에 추가한 파일을 초기화 해준다.
					}
				});
			});
		});
	</script>
</html>























