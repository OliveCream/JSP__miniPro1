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
<%@ page import="java.util.List" %>

<%
	Logger logger = LogManager.getLogger("/board/view.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	
	long ccsSeq = HttpUtil.get(request, "ccsSeq", (long)0);
	
	String ccsContent = HttpUtil.get(request, "ccsContent", "");
	logger.debug("댓글 내용 ----------- " + ccsContent);
	
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.boardSelect(bbsSeq);
	
	UserDao userDao = new UserDao();
	User user = null;
	user = userDao.userSelect(cookieUserId);
	
	
	if(board != null){// 조회수 증가
		boardDao.boardReadCntPlus(bbsSeq);
	}
	
	List<Comment> commentList = null;
	
	Comment cSearch = new Comment();
	CommentDao commentDao = new CommentDao();
	
	cSearch.setBbsSeq(bbsSeq);
	
	commentList = commentDao.commentList(cSearch);
	
	//댓글갯수 변수
	long commentCnt = 0;
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>view</title>
<%@ include file="/include/head.jsp" %>

<style type="text/css">
.btn.btn-primary{
  background-color:#3D4C74;
  color: #fff;
  border:none;
  border-radius:3px;
}

.comment_css {
  display: gird;
  place-content: center;
}
.card{
  width:100%;
  height:100%;
  margin: auto;
}
.btn-btn-primary{
  background-color:#3D4C74;
  color: #fff;
  border:none;
  border-radius:3px;
}
.badge{
  background-color:#3D4C74;
  color: #fff;
  border:none;
  border-radius:3px;	
}

 body {
   background: linear-gradient(to bottom, , white);
   /* 그라데이션 색상 및 방향 설정 */

 }
 
 .container {
   margin-top: 20px;  /* 내비게이션 바와 본문 간의 간격 조절 */
 }

</style>

<script>
$(document).ready(function(){
<%
	if(board == null){
%>
		alert("조회하신 게시물이 존재하지 않습니다.");
		document.bbsForm.action = "/board/list.jsp";
		document.bbsForm.submit();
<%
	}
	else{
%>
		$("#btnList").on("click", function(){
			document.bbsForm.action = "/board/list.jsp";
			document.bbsForm.submit();
		});
<%
		if(StringUtil.equals(cookieUserId, board.getUserId())){
%>
			$("#btnUpdate").on("click", function(){
				document.bbsForm.action = "/board/update.jsp";
				document.bbsForm.submit();
			});
			
			$("#btnDelete").on("click", function(){
				if(confirm("게시물을 삭제 하시겠습니까?") == true){
					document.bbsForm.action = "/board/delete.jsp";
					document.bbsForm.submit();
				}
			});
<%
		}
	}
%>


});



function fn_commentUpdate(){
	if($.trim($("#ccsContent").val()).length <= 0){
		alert("댓글 내용을 입력해주세요.");
		$("#ccsContent").val("");
		$("#ccsContent").focus();
		return;
	}
	document.ccsForm.action = "/board/commentUpdate.jsp";
	document.ccsForm.submit();
}

function fn_commentDelete(ccsSeq){
	document.ccsForm.ccsSeq.value = ccsSeq;
	document.ccsForm.action = "/board/commentDelete.jsp";
	docuemnt.ccsForm.submit();
}

</script>

<style>
 .container {
   margin-top: 70px;  /* 내비게이션 바와 본문 간의 간격 조절 */
 }
</style>

</head>


<body >

<%
if(board != null){
%>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
   <h2><b>게시물 보기</b></h2>
   <br />
   <div class="row" style="margin-right:0; margin-left:0;">
      <table class="table">
         <thead style="background-color: white;">
            <tr class="table-active">
               <th scope="col" style="width:60%">
                  <b>제목 : <%=board.getBbsTitle() %></b><br/>
                  작성자 : <%=board.getBbsName() %>
                  <a href="mailto:메일" style="color:#828282;">(<%=board.getUserId() %>) </a>       
               </th>
               <td scope="col" style="width:40%" class="text-right">
                  <%=board.getRegDate() %><br/>
                  조회 : <%=board.getBbsReadCnt() %> 
               </td>
            </tr>
         </thead>
         <tbody>
            <tr>
               <td colspan="2"><pre><%=board.getBbsContent() %> </pre></td>
            </tr>
         </tbody>
         <tfoot>
         <tr>
               <td colspan="2"></td>
           </tr>
         </tfoot>
      </table>
   </div>

   
   <button type="button" id="btnList" class="btn btn-primary" >리스트</button>
<%
	if(StringUtil.equals(cookieUserId, board.getUserId())){
%>
   <button type="button" id="btnUpdate" class="btn btn-primary">수정</button>
   <button type="button" id="btnDelete" class="btn btn-primary">삭제</button>

<%
	}
}
%>
   
   <br/>
   <br/>
   
	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="bbsSeq" value=<%=bbsSeq %> />
		<input type="hidden" name="searchType" value=<%=searchType %> />
		<input type="hidden" name="searchValue" value=<%=searchValue %> />
		<input type="hidden" name="curPage" value=<%=curPage %> />   	
	</form>
   
<!-- ---------------------------------- 댓글 ------------------------------------------------ -->

<form name="ccsForm" id="ccsForm" method="post" class = "comment_css">
   <div class="card">
        
        <input type="hidden" id="boardID" value=""/>
        
        <input type="hidden" name="bbsSeq" value=<%=bbsSeq %> />
		<input type="hidden" name="cookieUserId" value=<%=cookieUserId %> />
		<input type="hidden" name="ccsName" value=<%=user.getUserName() %> />
		
		<input type="hidden" name="searchType" value=<%=searchType %> />
		<input type="hidden" name="searchValue" value=<%=searchValue %> />
		<input type="hidden" name="curPage" value=<%=curPage %> />
		
         <div class="card-body">
            <textarea id="ccsContent" name="ccsContent" class="form-control" rows="1"></textarea>
         </div>
         <div class="card-footer">
            <button type="button" id="btn-reply-save" onclick="fn_commentUpdate()" class="btn-btn-primary">등록</button>
         </div>
         
      </div>
       
       <br />


     
   <div class="card">
	<div class="card-header" style="display: flex; justify-content: space-between;">
		<b>댓글 목록</b>
		<div><%=commentList.size() %>개</div>
	</div>
         
         <ul id="reply--box" class="list-group">
<%
if(commentList != null && commentList.size() > 0){
	for(int i = 0; i < commentList.size(); i++){
		Comment comment = commentList.get(i);
		cSearch.setCcsSeq(comment.getCcsSeq());
%>
            
            <li id="reply_<%=i %>" class="list-group-item d-flex justify-content-between">
				
				
				<div><%=comment.getCcsContent() %></div>
				<div class="d-flex">
                  <div class=""><%=comment.getCcsName() %>&nbsp;&nbsp;</div>
                  <div class=""><%=comment.getRegDate() %>&nbsp;&nbsp;</div>
<%
		if(StringUtil.equals(comment.getUserId(), cookieUserId)){
%>
                  <button class="badge" onclick="fn_commentDelete(<%=comment.getCcsSeq() %>)">삭제</button>
<%
		}
		else{
%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%
		}
%>
               </div>
            </li>
<%
	}
}
else{
%>
	<li class="list-group-item d-flex justify-content-between">
		<div>
			댓글이 없습니다.
		</div>
	</li>
<%
}
%>   
         </ul>
      </div>

<input type="hidden" name="ccsSeq" value="<%=cSearch.getCcsSeq() %>" />
	
</Form>
</div>
<br /><br /><br /><br /><br />	
</body>
</html>