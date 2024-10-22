<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%
	boolean connection = false;
	Connection conn = null;
	
	String driver = "oracle.jdbc.driver.OracleDriver";		//Class.forName 위한 거
	String url = "jdbc:oracle:thin:@localhost:1521:xe";	//getConnection에 들어갈 url / @뒤는 아이피 들어가는 경로. 오라클 포트로 설정함
	
	try
	{
		Class.forName(driver);		//드라이버 로딩
		conn = DriverManager.getConnection(url, "c##sistuser", "1234");		//커넥션맺기
		connection = true;
		System.out.println("DB 연결 성공");
	}
	catch(Exception e)
	{
		connection = false;
		System.out.println("DB 연결 실패");
		e.printStackTrace();
	}
	finally
	{
		if(conn!=null)
			conn.close();
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	if(connection == true)
	{
%>
	<h2>DB에 연결되었습니다.</h2>
<%
	}
	else
	{
%>
	<h2>DB연결에 실패하였습니다.</h2>
<%
	}
%>


</body>
</html>