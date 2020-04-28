<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Message</title>
</head>
<h2> Send a Message </h2>
<body>
<form action="messageSend.jsp" method="POST">
Message: <input type="text" name="message"/> <br/>
<input type="submit" value="Send" name="m1"/>
</form>
<a href="messageIndex.jsp">Back</a>
</body>
</html>