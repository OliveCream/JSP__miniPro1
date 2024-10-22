<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>



<!DOCTYPE html>
<style>
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

</style>
<form class = "comment_css">
   <div class="card">
        <form>
        <input type="hidden" id="boardID" value=""/>
         <div class="card-body">
            <textarea id="reply-content" class="form-control" rows="1"></textarea>
         </div>
         <div class="card-footer">
            <button type="button" id="btn-reply-save" class="btn-btn-primary">등록</button>
         </div>
         </form>
      </div>
       
       <br />
       
   <div class="card">
         <div class="card-header">댓글 리스트</div>
         <ul id="reply--box" class="list-group">
            
            <li id="reply--1" class="list-group-item d-flex justify-content-between">
               <div>댓글내용</div>
               <div class="d-flex">
                  <div class="">작성자&nbsp;&nbsp;</div>
                  <button class="badge">삭제</button>
               </div>
            </li>
   
         </ul>
      </div>
</form>