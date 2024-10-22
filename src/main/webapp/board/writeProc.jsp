<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.BoardDao" %>
<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.common.util.StringUtil" %>	

<%
	Logger logger = LogManager.getLogger("/board/writeProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	boolean bSuccess = false;
	String errorMsg = "";
	
	String bbsTitle = HttpUtil.get(request, "bbsTitle", "");
	String bbsContent = HttpUtil.get(request, "bbsContent", "");
	String bbsName = HttpUtil.get(request, "bbsName", "");
	
	if(!StringUtil.isEmpty(bbsTitle) && !StringUtil.isEmpty(bbsContent)){
		Board board = new Board();
		BoardDao boardDao = new BoardDao();
		
		board.setUserId(cookieUserId);
		board.setBbsName(bbsName);
		board.setBbsTitle(bbsTitle);
		board.setBbsContent(bbsContent);
		
		if(boardDao.boardInsert(board) > 0){
			bSuccess = true;
		}
		else{
			errorMsg = "게시물 등록 중 오류가 발생하였습니다. 다시 작성해 주세요.";
		}
	}
	else{
		errorMsg = "게시물 등록시 필요한 값이 올바르지 안습니다. 다시 입력해 주세요.";
	}
%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>writeProc</title>
<%@ include file="/include/head.jsp" %>

<script>

$(document).ready(function(){
<%
	if(bSuccess == true){
%>
		alert("게시물이 등록되었습니다.");
		location.href = "/board/list.jsp";
<%
	}
	else{
%>
		alert("<%=errorMsg %> ");
		location.href = "/board/write.jsp";
<%
	}
%>
	
});
</script>

</head>
<body>


</body>
</html>