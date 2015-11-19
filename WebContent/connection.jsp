<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang = "en">
<!-- This page shows option to upload the photo by browsing in the computer and upload it in bucket -->
	<head>
		<meta charset = "utf-8"/>
		<meta name = "description"	content = "connection page"/>
		<meta name = "author"	content = "Ronak Shah"/>
		<title> Uploading result </title>
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
	
<%@ page import="java.io.*"%>
<%@ page import="java.io.ByteArrayInputStream"%>
<%@ page import="java.io.InputStream"%>

<%@ page import="com.amazonaws.auth.BasicAWSCredentials"%>
<%@ page import="com.amazonaws.services.s3.AmazonS3"%>
<%@ page import="com.amazonaws.services.s3.AmazonS3Client"%>
<%@ page import="com.amazonaws.services.s3.model.CannedAccessControlList"%>
<%@ page import="com.amazonaws.services.s3.model.ObjectMetadata"%>

<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.DriverManager"%>

<%
	String save_file = "";
	String desc = "";
	
	Statement stat = null;
	Connection connec = null;
	PreparedStatement preStat = null;
	
	String content_type = request.getContentType(); 
	// Means response that we are going to send to the client is one of the MIME type
		if((content_type != null) && (content_type.indexOf("multipart/form-data")>=0)){
		// Means if content_type has some value then only we will proceed
			DataInputStream in = new DataInputStream(request.getInputStream());
			// DIS helps to write and read primitive data type to a media such as file
			int length = request.getContentLength();
			//gives length of the content
			byte data_bytes[] = new byte[length];
			int bytes_read = 0;
			int total_bytes_read = 0;
			while (total_bytes_read < length){
				bytes_read = in.read(data_bytes, total_bytes_read, length);
				total_bytes_read += bytes_read;
			}
			// contents in the file is read in string
			String file = new String(data_bytes);
			desc = file;
			
			save_file = file.substring(file.indexOf("filename=\"")+10);
			save_file = save_file.substring(0, save_file.indexOf("\n"));
			save_file = save_file.substring(save_file.lastIndexOf("\\")+ 1, save_file.indexOf("\""));
			int last_index = content_type.lastIndexOf("=");
			String boundary = content_type.substring(last_index + 1, content_type.length());
			int position;
			
			position = file.indexOf("filename=\"");
			position = file.indexOf("\n", position) + 1;
			position = file.indexOf("\n", position) + 1;
			position = file.indexOf("\n", position) + 1;
			
			int boundary_location = file.indexOf(boundary, position) - 4;
			int start_position = ((file.substring(0, position)).getBytes()).length;
			int end_position = ((file.substring(0, boundary_location)).getBytes()).length;
			
			String name = save_file;
			
			File files = new File(save_file);
			FileOutputStream file_out = new FileOutputStream(files);
			file_out.write(data_bytes, start_position, (end_position - start_position));
			
			//get photo descccription from the form
	         desc = desc.substring(desc.indexOf("name=\"desc\"")+12);
	    	desc = desc.substring(0,desc.indexOf("------"));
			
						try {
				Class.forName("com.mysql.jdbc.Driver");
				//  connect to database
				connec = DriverManager
						  .getConnection("jdbc:mysql://rshah.c8zjbixrssjy.ap-southeast-2.rds.amazonaws.com/innodb",
									"rshah", "bhavna07");

				stat = connec.createStatement();
				// Insert data in the database
				preStat = connec.prepareStatement("insert into  innodb.photoAlbum values ('"+ name 
																+ "', '" + desc + "')");
				// This statement will excute the above statement
				preStat.executeUpdate();	
			
			%>
			<!-- Links to go back and download photo -->
				<a href="index.jsp">Go Back</a></br>
				<a href="fileDownload.jsp">View Photo Album</a>	
					
			<%
						} catch (Exception ex) {
				 			throw ex;
				 		} finally {
				 			connec.close();
				 		}			
					
						// bucket name
						String bucket_name = "r.shah";
					
						byte[] content = new byte[(int) files.length()];
						try {
							//set the credentials
							AmazonS3 client = new AmazonS3Client(
									new BasicAWSCredentials("AKIAIQK2HLYNPERVYG5Q",
											"RppGRXgNfyYFDod8lCJpoWpPRZWG8P99xkd3dAXE"));							
							InputStream in_stream = new FileInputStream(files);
							ObjectMetadata meta_data = new ObjectMetadata();
							meta_data.setContentLength(content.length);
							meta_data.setContentType("application/jpg");
							client.putObject(bucket_name, name, in_stream, meta_data);
							client.setObjectAcl(bucket_name, name, CannedAccessControlList.PublicRead);
							
						%>	
						</br>
						<span>Congratulation</span>
						<p>Successfully uploaded to S3 bucket and even database is updated !cheers</p>
					
						<%
						}// if error occurs it will catch the exception
						catch (Exception ex) {
							System.out.println(ex);
						}
						file_out.flush();
						file_out.close();
							} 
						%>
					
				</body>
			</html>	