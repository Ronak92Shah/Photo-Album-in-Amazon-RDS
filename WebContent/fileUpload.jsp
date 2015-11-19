<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang = "en">
<!-- This page shows option to upload the photo by browsing in the computer and upload it in bucket -->
	<head>
		<meta charset = "utf-8"/>
		<meta name = "description"	content = "fileUpload Page"/>
		<meta name = "author"	content = "Ronak Shah"/>
		<title> Upload the photo </title>
	</head>
		<body>
			<style>
		<!-- Style of the Page -->
				body {background-color:lightgray;
						text-align : center;}
				h1   {color:blue;}
				p    {color:green;}
				span {color:red;}
			</style>
			<h1> Add Photos to your Album</h1>
		<!-- This helps to browse in the computer -->
		<form ENCTYPE = "multipart/form-data"	ACTION = "connection.jsp"	METHOD= post>
			<p> Select your photo: 
			<input name="file" type="file" required = "required">
			</p>
			<p>Add Description
			<input name="desc" type="text" required = "required" >
			</p>
			<span>Note: Both the fields are compulsory</span>
			<p>
			<input type="submit" value="Upload">
			</p>
		</form>
	</body>
</html>