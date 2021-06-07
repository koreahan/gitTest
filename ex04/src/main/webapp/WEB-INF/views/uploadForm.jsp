<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>File Upload - form</title>
</head>
<body>
	<form action="uploadFormAction" method="post" enctype="multipart/form-data">
	<!-- multiple 속성을 작성하면, 여러 개의 파일을 업로드할 수 있다. -->
	<!-- 컨트롤러에 전달할 때에는 uploadFile이라는 배열형태로 전달된다. -->
		<input type="file" name="uploadFile" multiple>
		<button>Submit</button>
	</form>
</body>
</html>