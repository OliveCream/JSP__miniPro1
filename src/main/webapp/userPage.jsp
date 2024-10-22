<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.dao.BoardDao" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="java.util.List" %>

<%
	Logger logger = LogManager.getLogger("/userPage.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	List<Board> list = null;
	BoardDao boardDao = new BoardDao();
	
	User user = null;
	
	if(!StringUtil.isEmpty(cookieUserId)){
		logger.debug("[userPage] cookieUserId - " + cookieUserId);
		
		UserDao userDao = new UserDao();
		user = userDao.userSelect(cookieUserId);
		
		list = userDao.myBoardList(cookieUserId);
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>userPage</title>
<%@ include file="/include/head.jsp" %>

<script>
$(document).ready(function(){
	$("#btnList").on("click", function(){
		document.bbsForm.action = "/board/list.jsp";
		document.bbsForm.submit();
	});
});


</script>


<style>
 .container {
   margin-top: 70px;
 }
</style>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
    
    <div class="row mt-5">
       <h2><b>마이 페이지</b></h2>
    </div>
    <br />
    <div class="row mt-2">
        <div class="col-12">
                <div class="form-group">
                    <label for="username">ㆍ사용자 아이디</label>
                    <input type="text" class="form-control" id="userId" name="userId" value="<%=user.getUserId() %>" placeholder="사용자 아이디" maxlength="12" readonly style="background-color: white"/>
                </div>

                <div class="form-group">
                    <label for="username">ㆍ사용자 이름</label>
                    <input type="text" class="form-control" id="userName" name="userName" value="<%=user.getUserName() %>" placeholder="사용자 이름" maxlength="15" readonly style="background-color: white"/>
                </div>
                <div class="form-group">
                    <label for="username">ㆍ사용자 이메일</label>
                    <input type="text" class="form-control" id="userEmail" name="userEmail" value="<%=user.getUserEmail() %>" placeholder="사용자 이메일" maxlength="30" readonly style="background-color: white"/>
                </div>
                
                <br /><br />
                <input type="hidden" id="userPwd" name="userPwd" value="" />		<!-- hidden은 개발자가 사용한다 -->
                <button type="button" id="btnList" class="btn btn-primary" style="background-color: #3D4C74;">리스트</button>&nbsp;
                <button type="button" id="btnReg" class="btn btn-primary" style="background-color: #3D4C74;">등록</button>
        </div>
    </div>
    
    
    <!--------------- 내가쓴 게시물 보기 ------------------------------------>
    
    <br /><br /><br /><br />
    <h3>작성한 게시물 보기</h3><br />
<%
logger.debug("리스트 사이즈 - " + list.size());
if(list != null && list.size() >0){
	for(int i = 0; i < list.size(); i++){
		Board board = list.get(i);
%>
   <div class="row" style="margin-right:0; margin-left:0;">
      <table class="table">
         <thead>
            <tr class="table-active">
               <th scope="col" style="width:60%">
					제목 : <%=board.getBbsTitle()%><br/>
               </th>
               <td scope="col" style="width:40%" class="text-right">
                  <%=board.getRegDate()%> 조회 : <%=board.getBbsReadCnt()%>
               </td>
            </tr>
         </thead>
         <tbody>
            <tr>
               <td colspan="2"><pre><%=board.getBbsContent()%></pre></td>
            </tr>
         </tbody>
         <tfoot>
         <tr>
               <td colspan="2"></td>
           </tr>
         </tfoot>
      </table>
   </div>
   
<%
	}
}	
%>   
   <button type="button" id="btnList" class="btn btn-secondary">리스트</button>
   <button type="button" id="btnUpdate" class="btn btn-secondary">수정</button>
   <button type="button" id="btnDelete" class="btn btn-secondary">삭제</button>
   <br /><br /><br /><br />
</div>



	<form name="bbsForm" id="bbsForm" method="post" >
		<input type="hidden" name="searchType" value="<%=searchType %>" />
		<input type="hidden" name="searchValue" value="<%=searchValue %>" />
		<input type="hidden" name="curPage" value="<%=curPage %>" />
	</form>
</body>
</html>