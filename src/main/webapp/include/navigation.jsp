<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>

<script>
function fn_confirm(){
	if(confirm("로그아웃 하시겠습니까?") == true){
		location.href = "/logout.jsp";
	}
}
</script>

<style>
.navbar {
    height: 60px; /* 원하는 높이로 조절하세요 */
    background-color: #66718D; /* 배경색을 원하는 색으로 설정하세요 */
}
    
.navbar-nav .nav-link {
     color: white !important; /* 흰색으로 설정, !important는 다른 스타일을 덮어쓰기 위해 사용 */
}

a:hover {
    cursor: pointer; /* 링크에 마우스를 올렸을 때 포인터 모양으로 변경 */
}
</style>

</head>
<body>
<nav class="navbar navbar-expand-lg bg-body-tertiary">
 <div class="container-fluid">
    <a class="navbar-brand" href="/etc.jsp">🎹</a>
    
	
	<div class="collapse navbar-collapse" id="navbarNav" align="right">
		<ul class="navbar-nav ms-auto mb-2 mb-lg-0">
		    
			<li class="nav-item">
				<a class="nav-link" href="/board/list.jsp">게시판</a>
			</li>
			
			<li class="nav-item">
				<a ></a> <!-- onclick='return confirm("정말?");' -->
			</li>
		
		</ul>
	</div>
    
	<div align="right">
		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav ms-auto mb-2 mb-lg-0">
			    
			    <li class="nav-item">
					<a class="nav-link" href="/userPage.jsp" >마이페이지</a>
				</li>
			    
				<li class="nav-item">
					<a class="nav-link" href="/userUpdateForm.jsp" >회원정보수정</a>
				</li>
				
				<li class="nav-item">
					<a class="nav-link active" aria-current="page" onclick="fn_confirm()" >로그아웃</a> 
				</li>
			    
			</ul>
		</div>
	</div>
    
 </div>
</nav>
</body>
</html>

