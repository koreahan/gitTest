<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
								<p>게시글 수정</p>
							</header>
									<!-- Table -->
							<h3><a href="/board/list${cri.getListLink()}" class="button small">목록 보기</a></h3>
						<div class="content">
							<div class="form">
								<form role="form" method="post" action="/board/modify">
									<input type="hidden" name="pageNum" value="${cri.pageNum}">
									<input type="hidden" name="amount" value="${cri.amount}">
									<input type="hidden" name="keyword" value="${cri.keyword}">
									<input type="hidden" name="type" value="${cri.type}">
									<div class="fields">
										<div class="field">
											<h4>번호</h4>
											<input name="bno" type="text" value="${board.bno}" readonly/>
										</div>
										<div class="field">
											<h4>*제목</h4>
											<input name="title" type="text" value="${board.title}"/>
										</div>
										<div class="field">
											<h4>*내용</h4>
											<textarea name="content" rows="6" style="resize:none">${board.content}</textarea>
										</div>
										<div class="field">
											<h4>작성자</h4>
											<input name="writer" type="text" value="${board.writer}" readonly/>
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
										<li>
											<input type="submit" class="button" value="수정 완료"/>
										</li>
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
			var uploadResult = $(".uploadResult ul");
			var cloneObj = $(".uploadDiv").clone();
			var contextPath = "${pageContext.request.contextPath}";
			var regex = new RegExp("(.*/)\.(exe|sh|zip|alz)");
			var maxSize = 1024 * 1024 * 5; //5MB
			
			function checkExtension(fileName, fileSize){
				if(regex.test(fileName)){
					alert("업로드 할 수 없는 확장자입니다.");
					return false;
				}
				
				if(fileSize >= maxSize){
					alert("파일 사이즈 초과");
					return false;
				}
				return true;
			}
			
			$(".uploadDiv").on("change", "input[type='file']", function(e){
				console.log("들어옴");
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;
				
				for(let i=0; i<files.length; i++){
					if(!checkExtension(files[i].name, files[i].size)){
						return false;
					}
					formData.append("uploadFile", files[i]);
				}
				
				$.ajax({
					url: '/uploadAjaxAction',
					processData: false,
					contentType: false,
					data: formData,
					type: "post",
					dataType: "json",
					success: function(result){
						console.log(result);
						if(result.failureList.length != 0){
							var str = "";
							for(let i=0; i<result.failureList.length; i++){
								str += result.failureList[i].fileName + "\n";
							}
							alert("지원하지 않는 파일의 형식은 제외되었습니다.\n" + str);
						}
						
						//썸네일 실행
						showUploadResult(result.succeedList);
						//기존에 있던 input태그 대신 DOM으로 넣었기 때문에 change 이벤트도 위임을 통해 사용해야 한다.
						$(".uploadDiv").html(cloneObj.html());
					}
				});
			});
			
			function showUploadResult(uploadResults){
				var str = "";
				$(uploadResults).each(function(i, obj){
					if(!obj.fileType){
						//일반 파일
						var filePath = encodeURIComponent(obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName);
						str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.fileType + "'>"
						str += "<div><img src='/resources/images/attach.png' width=100 height=100>";
						str += "<br>" + obj.fileName;
						str += "&nbsp;&nbsp;&nbsp;<span data-file='" + filePath + "' data-type='file'>x</span></div></li>";
					}else{
						//이미지 파일
						var thumbPath = encodeURIComponent(obj.uploadPath + "\\s_" + obj.uuid + "_" + obj.fileName);
						str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.fileType + "'>"
						str += "<div><img src='/display?fileName=" + thumbPath + "' width=100 height=100>";
						str += "<br>" + obj.fileName;
						str += "&nbsp;&nbsp;&nbsp;<span data-file='" + thumbPath + "' data-type='image'>x</span></div></li>";
					}
				});
				uploadResult.append(str);
			}
			
			$(".uploadResult").on("click", "li", function(e){
	   			console.log("view or download")
	   			var li = $(this);
	   			var path = encodeURIComponent(li.data("path") + "/" + li.data("uuid") + "_" + li.data("filename"));
	   			
	   			if(li.data("type")){
	   				//썸네일
	   				showImage(path.replace(new RegExp(/\\/g), "/"));
	   			}else{
	   				//다운로드
	   				self.location = "/download?fileName=" + path; 
	   			}
	   		});
	   		var check = false;
	   		function showImage(path){
	   			if(check){return;}
	   			$(".bigPictureWrapper").css("display", "flex").show();
	   			$(".bigPicture").html("<img src='/display?fileName=" + path + "'>")
	   			.animate({width:'100%', height:'100%'}, 1000);
	   			check = true;
	   			
	   		}
			$(".bigPictureWrapper").on("click", function(e){
				if(!check){return;}
				$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
				setTimeout(function(){
					$(".bigPictureWrapper").hide();
					check = false;
				}, 1000);
			});
			
			$(".uploadResult").on("click", "span", function(e){
				if(confirm("파일을 삭제하시겠습니까?")){
					$(this).closest("li").remove();
				}
				//수정부분에서는 경로의 파일까지는 삭제하지 않는다(실시간 DB조회 라이브러리로 해결)
			});
			
			$("input[type='submit']").on("click", function(e){
				e.preventDefault();
				console.log("submit clicked");
				var form = $("form[role='form']");
				var str = "";
				
				$(".uploadResult ul li").each(function(i, obj){
				//obj는 JS이다, data()는 jQuery이기 때문에 $()로 감싸준다.
					str += "<input type='hidden' name='attachList[" + i +"].uploadPath' value='" + $(obj).data("path") + "'>";
					str += "<input type='hidden' name='attachList[" + i +"].uuid' value='" + $(obj).data("uuid") + "'>";
					str += "<input type='hidden' name='attachList[" + i +"].fileName' value='" + $(obj).data("filename") + "'>";
					str += "<input type='hidden' name='attachList[" + i +"].fileType' value='" + $(obj).data("type") + "'>";
				});
				form.append(str).submit();
			});
			
			(function(){
	   			var bno = "${board.bno}";
	   			console.log(bno);
	   			$.getJSON("/board/getAttachList", {bno:bno}, function(list){
	   				var str = "";
	   				
	   				$(list).each(function(i, obj){
	   					if(obj.fileType){
	   						var thumbPath = encodeURIComponent(obj.uploadPath + "\\s_" + obj.uuid + "_" + obj.fileName);
	   						str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.fileType + "'>"
							str += "<div><img src='/display?fileName=" + thumbPath + "' width=100 height=100>";
							str += "<br>" + obj.fileName;
							str += "&nbsp;&nbsp;&nbsp;<span data-file='" + thumbPath + "' data-type='image'>x</span></div></li>";
	   					}else{
	   						var filePath = encodeURIComponent(obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName);
							str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.fileType + "'>"
							str += "<div><img src='/resources/images/attach.png' width=100 height=100>";
							str += "<br>" + obj.fileName;
							str += "&nbsp;&nbsp;&nbsp;<span data-file='" + filePath + "' data-type='file'>x</span></div></li>";
	   					}
	   				});
	   				$(".uploadResult ul").html(str);
	   			});
	   		})();
		})
	</script>
</html>





