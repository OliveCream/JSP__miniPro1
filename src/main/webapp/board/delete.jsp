<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.BoardDao" %>
<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<%
	Logger logger = LogManager.getLogger("/board/delete.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	boolean dSuccess = false;
	String errorMsg = "";
	
	long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);

	if(bbsSeq > 0){
		BoardDao boardDao = new BoardDao();
		Board board = boardDao.boardSelect(bbsSeq);
		
		if(board != null){
			if(StringUtil.equals(cookieUserId, board.getUserId())){
				if(boardDao.boardDelete(bbsSeq) > 0 ){
					dSuccess = true;
				}
				else{
					errorMsg = "게시물 삭제 중 오류가 발생했습니다.";
				}
			}
			else{
				errorMsg = "로그인 사용자의 게시물이 아닙니다.";
			}
		}
		else{
			errorMsg = "해당 게시글이 존재하지 않습니다.";
		}
	}
	else{
		errorMsg = "게시물 번호가 올바르지 않습니다.";
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>delete</title>
<%@ include file="/include/head.jsp" %>
<script>
	$(document).ready(function(){
<%
	if(dSuccess == true){
		
%>
		alert("게시물이 삭제되었습니다.");
<%
	}
	else{
%>
		alert("<%=errorMsg %>");
<%
	}
%>
		location.href = "/board/list.jsp";
	});
</script>
</head>
<body>

</body>
</html>