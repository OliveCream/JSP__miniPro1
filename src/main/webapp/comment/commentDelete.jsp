<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.dao.BoardDao" %>
<%@ page import="com.sist.web.dao.CommentDao" %>
<%@ page import="com.sist.web.model.Comment" %>
<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.common.util.StringUtil" %>


<%
	Logger logger = LogManager.getLogger("/board/delete.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
	
	boolean dSuccess = false;
	String errorMsg = "";
	
	long ccsSeq = HttpUtil.get(request, "ccsSeq", (long)0);
	
	if(ccsSeq > 0){
		CommentDao commentDao = new CommentDao();
		Comment comment = commentDao.commentSelect(ccsSeq);
		
		if(comment != null){
			if(StringUtil.equals(cookieUserId, comment.getUserId())){
				if(commentDao.commentDelete(ccsSeq) > 0){
					dSuccess = true;
				}
				else{
					errorMsg = "삭제 중 예상치 못한 오류가 발생하였습니다.";
				}
			}
			else{
				errorMsg = "본인의 댓글만 삭제할 수 있습니다.";
			}
		}
		else{
			errorMsg = "댓글이 존재하지 않습니다.";
		}
	}
	else{
		errorMsg = "댓글 번호가 올바르지 않습니다.";
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>commentDelete</title>
<%@ include file="/include/head.jsp" %>
<script>
	$(document).ready(function(){
<%
	if(dSuccess == true){
		
%>
		alert("댓글이 삭제되었습니다.");
<%
	}
	else{
%>
		alert("<%=errorMsg %>");
<%
	}
%>
		document.bbsForm.action = "/board/view.jsp";
		document.bbsForm.submit();
	});
</script>
</head>
<body>
<form name="bbsForm" id="bbsForm" method="post">
	<input type="hidden" name="bbsSeq" value=<%=bbsSeq %> />
</form>
</body>
</html>