package com.sist.web.model;

import java.io.Serializable;

public class Paging implements Serializable{

	private static final long serialVersionUID = 1L;

	private long totalPostCnt;		//총 게시물 수
	private long totalPage;			//총 페이지 수
	private long startRow;			//게시물 시작 row (오라클 rownum)
	private long endRow;			//게시물 끝 row (오라클 rownum)
	private long listCount;			//한 페이지에 있는 게시물 수
	private long pageCount;			//페이지를 몇개 씩 나타나게 할 것인지
	private long curPage;			//현재 페이지
	
	private long startPage;			//시작 페이지 번호
	private long endPage;			//종료 페이지 번호
	
	private long totalBlock;		//총 블럭 수
	private long curBlock;			//현재 블럭
	
	private long prevBlockPage;		//이전 블럭 페이지
	private long nextBlockPage;		//다음 블럭 페이지
	
	private long startNum;
	
	
	public Paging(long totalCount, long listCount, long pageCount, long curPage) {
		this.totalPostCnt = totalCount;
		this.listCount = listCount;
		this.pageCount = pageCount;
		this.curPage = curPage;
		
		if(totalCount > 0) {
			pagingProc();
		}
	}
	
	
	
	
	public long gettotalPostCnt() {
		return totalPostCnt;
	}
	public void settotalPostCnt(long totalCount) {
		this.totalPostCnt = totalCount;
	}


	public long getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(long totalPage) {
		this.totalPage = totalPage;
	}


	public long getStartRow() {
		return startRow;
	}
	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}


	public long getEndRow() {
		return endRow;
	}
	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}


	public long getListCount() {
		return listCount;
	}
	public void setListCount(long listCount) {
		this.listCount = listCount;
	}


	public long getPageCount() {
		return pageCount;
	}
	public void setPageCount(long pageCount) {
		this.pageCount = pageCount;
	}


	public long getCurPage() {
		return curPage;
	}
	public void setCurPage(long curPage) {
		this.curPage = curPage;
	}


	public long getStartPage() {
		return startPage;
	}
	public void setStartPage(long startPage) {
		this.startPage = startPage;
	}


	public long getEndPage() {
		return endPage;
	}
	public void setEndPage(long endPage) {
		this.endPage = endPage;
	}


	public long getTotalBlock() {
		return totalBlock;
	}
	public void setTotalBlock(long totalBlock) {
		this.totalBlock = totalBlock;
	}


	public long getCurBlock() {
		return curBlock;
	}
	public void setCurBlock(long curBlock) {
		this.curBlock = curBlock;
	}


	public long getPrevBlockPage() {
		return prevBlockPage;
	}
	public void setPrevBlockPage(long prevBlockPage) {
		this.prevBlockPage = prevBlockPage;
	}


	public long getNextBlockPage() {
		return nextBlockPage;
	}
	public void setNextBlockPage(long nextBlockPage) {
		this.nextBlockPage = nextBlockPage;
	}


	public long getStartNum() {
		return startNum;
	}
	public void setStartNum(long startNum) {
		this.startNum = startNum;
	}





	//페이징 계산 프로세스
	private void pagingProc() {
		//총 페이지 수 구하기
		totalPage = (long)Math.ceil((double)totalPostCnt / listCount);		//ceil -> 올림 (글이 5의 배수에 하나라도 있으면 페이지추가가 되야하기 때문)  | listCount - 한페이지에 보여줄 게시물 수
		System.out.println("---------------------------------------------------");
		System.out.println("totalCount : " + totalPostCnt + " / listCount : " + listCount);
		System.out.println("totalPage : " + totalPage);
		System.out.println("---------------------------------------------------");
		
		//총 블럭 수 구하기
		totalBlock = (long)Math.ceil((double)totalPage / pageCount);		//totalPage 총 페이지 수, pageCount - 페이징 범위 수
		//현재 블럭 구하기
		curBlock = (long)Math.ceil((double)curPage / pageCount);
		//시작 페이지 구하기
		startPage = ((curBlock - 1) * pageCount) + 1;
		//끝 페이지 구하기
		endPage = (startPage + pageCount) - 1;
		
		//마지막 페이지 보정 - 총페이지보다 끝 페이지가 크다면 총 페이지를 마지막 페이지로 변환함.
		if(endPage > totalPage) {
			endPage = totalPage;
		}
		
		//시작 rownum (oracle rownum)
		startRow = ((curPage - 1) * listCount) + 1;		//현재 페이지의 rownum 첫번째와 마지막 값 구하기 (startRow / endRow)
		//끝 ronnum (oracle rownum)
		endRow = (startRow + listCount) - 1;
		
		//게시물 시작 번호
		startNum = totalPostCnt - ((curPage - 1) * listCount);		//
		
		//이전 블럭 페이지 번호
		if(curBlock > 1) {
			prevBlockPage = startPage - 1;
		}
		
		//다음 블럭 페이지 번호
		if(curBlock < totalBlock) {
			nextBlockPage = endPage + 1;
		}
	}
	
}
