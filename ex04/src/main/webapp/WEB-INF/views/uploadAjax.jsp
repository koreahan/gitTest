<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>File Upload - Ajax </title>
<style>
	.uploadResult{
		width: 100%;
	}
	
	.uploadResult ul{
		display: flex;
		justify-content: center;
	}
	
	.uploadResult ul li{
		list-style: none;
		padding: 10px;
	}
	.bigPicture{
		text-align: center;
	}
	
</style>
</head>
<body>
	<h1>File Upload - Ajax</h1>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	<div class="uploadResult">
		<h3>가져오기 성공한 파일</h3>
		<ul></ul>
	</div>
	<button id="uploadBtn">upload</button>
	
	<div class="bigPictureWrapper">
		<div class="bigPicture"></div>
	</div>
	
	<div class="uploadFail" style="display:none;">
		<h3>가져오기 실패한 파일</h3>
		<h2>지원하지 않는 형식입니다.</h2>
		<ul></ul>
	</div>
</body>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script>
	var check = false;
	function showImage(fileCallPath){
		//alert(fileCallPath);
		if(check){return;}
		$(".bigPictureWrapper").css("display", "flex").show();
		
		$(".bigPicture").html("<img src='/upload/display?fileName=" + encodeURIComponent(fileCallPath) + "'>")
		.animate({width:"100%", height:"100%"}, 1000);
		check = true;
	}

	$(".bigPictureWrapper").on("click", function(e){
		if(!check){return;}
		$(".bigPicture").animate({width:"0%", height:"0%"}, 1000);
		setTimeout(function(){
			check = false;
			$(".bigPictureWrapper").hide();
		}, 1000)
	});
	
	$(document).ready(function(){
		var contextPath = "${pageContext.request.contextPath}";
		var uploadResult = $(".uploadResult ul");
		var uploadFail = $(".uploadFail ul");
		var cloneObj = $(".uploadDiv").clone();
		
		function showUploadFile(uploadResults, tag){
			str = "";
			$(uploadResults).each(function(i, obj){
				if(!obj.image){
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
					str += "<li><div><a href='/upload/download?fileName=" + fileCallPath + "'><img src='/upload/resources/img/attach.png'>" + obj.fileName + "</a>";
					/* 
						data속성은 Map구조로 DOM객체에서 사용할 수 있다.
						<span data-key="value">
						$("span").data("key") == "value"
					*/
					str += "<span data-file='" + fileCallPath + "' data-type='file'>x</span></div></li>"
				}else{
					//encodeURIComponent("문자열값")
					//get방식으로 전송 시 파라미터로 전달할 때, 값에 인식할 수 없는 문자가 있을 경우 쿼리 스트링 문법에 맞게 변경해야 한다.
					//이 때 사용하는 메소드이다.
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
					var originPath = obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName;
					originPath = originPath.replace(new RegExp(/\\/g), "/");
					str += "<li><div><a href=\"javascript:showImage(\'" + originPath + "\')\"><img src='/upload/display?fileName=" + fileCallPath + "'>" + obj.fileName + "</a>";
					str += "<span data-file='" + fileCallPath + "' data-type='image'>x</span></div></li>"
				}
			})
			$(tag).append(str);
		}
		
		$(".uploadResult").on("click", "span", function(e){
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			var li = $(this).parents("li");
			console.log(targetFile);
			console.log(type);
			$.ajax({
				url: contextPath + "/deleteFile",
				data: {fileName:targetFile, type:type},
				dataType: "text",
				type: "post",
				success: function(result){
					alert(result);
					li.remove();
				}
			});
		})
		
		function check(fileName, fileSize){
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 5242880; //5MB
			if(regex.test(fileName)){
				alert("업로드 할 수 없는 파일의 형식입니다.");
				return false;
			}
			if(fileSize > maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			return true;
		}
		
		$("#uploadBtn").on("click", function(){
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			
			console.log(files);
			
			for(let i=0; i<files.length; i++){
				if(!check(files[i].name, files[i].size)){
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url: contextPath + "/uploadAjaxAction",
				processData: false,
				contentType: false,
				data: formData,
				type: "post",
				dataType: "json",
				success: function(result){
					console.log(result);
					showUploadFile(result.succeedList, uploadResult);
					if(result.failureList.length != 0){
						showUploadFile(result.failureList, uploadFail);
						$(".uploadFail").show();
					}else{
						$(".uploadFail").hide();
					}
					$(".uploadDiv").html(cloneObj.html());
				}
			});
		});
	});
</script>
</html>


















