<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Photo Album</title>
</head>
<body>
		<style>
		<!-- Style of the Page -->
			body {background-color:lightgray;
					text-align : center;}
			table{align:center;}
			h1   {color:blue;}
			p    {color:green;}
			span {color:red;}
		</style>
<table border=1>
<tr>

<%@page import = "java.io.ByteArrayInputStream"%>
<%@page import = "java.io.File"%>
<%@page import = "java.util.List"%>
<%@page import = "com.amazonaws.auth.AWSCredentials"%>
<%@page import = "com.amazonaws.auth.BasicAWSCredentials"%>
<%@page import = "com.amazonaws.util.StringUtils"%>
<%@page import = "com.amazonaws.services.s3.AmazonS3"%>
<%@page import = "com.amazonaws.services.s3.AmazonS3Client"%>
<%@page import = "com.amazonaws.services.s3.model.Bucket"%>
<%@page import = "com.amazonaws.services.s3.model.CannedAccessControlList"%>
<%@page import = "com.amazonaws.services.s3.model.GeneratePresignedUrlRequest"%>
<%@page import = "com.amazonaws.services.s3.model.GetObjectRequest"%>
<%@page import = "com.amazonaws.services.s3.model.ObjectListing"%>
<%@page import = "com.amazonaws.services.s3.model.ObjectMetadata"%>
<%@page import = "com.amazonaws.services.s3.model.S3ObjectSummary"%>
<%@page import = "com.amazonaws.ClientConfiguration"%>
<%@page import = "com.amazonaws.Protocol"%>

<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.DriverManager"%>

 <!-- Heading of the table -->
<th>Photo</th>
<th>Name</th>
<th>Description</th>

</tr>
	<%		
		Connection connec = null;
		Statement stat = null;
		PreparedStatement preStat = null;
		ResultSet result = null;
		Class.forName("com.mysql.jdbc.Driver");
		// connecting to database
		connec = DriverManager
		  .getConnection("jdbc:mysql://rshah.c8zjbixrssjy.ap-southeast-2.rds.amazonaws.com/innodb",
				"rshah", "bhavna07");
		//select query to get name and description from the table 
		preStat = connec.prepareStatement("SELECT photoName, description from innodb.photoAlbum");
	
		//Results of the SQl query
		result = preStat.executeQuery();
		
		// Enter the Credentials
		String access_key = "AKIAIQK2HLYNPERVYG5Q";
		String secret_key = "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";
		AWSCredentials credential = new BasicAWSCredentials(access_key, secret_key);
		// Creates connection to interact with the server
		ClientConfiguration client_config = new ClientConfiguration();
		client_config.setProtocol(Protocol.HTTP);
		
		AmazonS3 conn = new AmazonS3Client(credential, client_config);
		conn.setEndpoint("s3-ap-southeast-2.amazonaws.com");
		//List<Bucket> buckets = conn.listBuckets();
		// Gets the list of object in the bucket and print it out
		ObjectListing object = conn.listObjects("r.shah");
		do { 
			// loop through to get all images
			for (S3ObjectSummary objects : object
					.getObjectSummaries()) {
				out.print("<tr><td><img src=\"https://s3-ap-southeast-2.amazonaws.com/r.shah/"
						+ objects.getKey() + "\"/></td>");
				result = preStat.executeQuery();
				
				out.print("<td>" + objects.getKey() + "<\td>" );
				
				while (result.next()) {

				    String photo_name = result.getString("photoName");
				    String desc = result.getString("description"); 
				// check photo name, helps to get description
				    if(objects.getKey().equals(photo_name)){
					// Description 
				out.print("<td>" + desc +"</td></tr>"); 
				    }
				  }
		        }	
		        object = conn.listNextBatchOfObjects(object);
		} while (object.isTruncated());
	%>
				<!-- Links to go back and upload photo -->
				<a href="index.jsp">Go Back</a></br>
				<a href="fileUpload.jsp">Upload Photo in Album</a>
</table>
</body>
</html>