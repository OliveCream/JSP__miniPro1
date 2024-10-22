<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%
	Logger logger = LogManager.getLogger("logOut.jsp");
	HttpUtil.requestLogString(request, logger);
	
	
%>

<!DOCTYPE html>
<html>
<head>
<title>logOut</title>
<script>
if(confirm("로그아웃 하시겠습니까?") == true){
<%
	if(CookieUtil.getCookie(request, "USER_ID") != null){
		CookieUtil.deleteCookie(request, response, "USER_ID");
	}
	response.sendRedirect("/");
%>
}

</script>


</head>
<body>

</body>
</html>


