package com.sist.web.model;

import java.io.Serializable;

public class Board implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private long bbsSeq;
	private String userId;
	private String bbsName;
	private String bbsTitle;
	private String bbsContent;
	private int bbsReadCnt;
	private String regDate;

	private long startRow;
	private long endRow;	
	
	
	public Board() {
		bbsSeq = 0;
		userId = "";
		bbsName = "";
		bbsTitle = "";
		bbsContent = "";
		bbsReadCnt = 0;
		regDate = "";
		
		startRow = 0;
		endRow = 0;
	}
	
	
	
	public long getBbsSeq() {
		return bbsSeq;
	}
	public void setBbsSeq(long bbsSeq) {
		this.bbsSeq = bbsSeq;
	}
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getBbsName() {
		return bbsName;
	}
	public void setBbsName(String bbsName) {
		this.bbsName = bbsName;
	}

	public String getBbsTitle() {
		return bbsTitle;
	}
	public void setBbsTitle(String bbsTitle) {
		this.bbsTitle = bbsTitle;
	}

	public String getBbsContent() {
		return bbsContent;
	}
	public void setBbsContent(String bbsContent) {
		this.bbsContent = bbsContent;
	}

	public int getBbsReadCnt() {
		return bbsReadCnt;
	}
	public void setBbsReadCnt(int bbsReadCnt) {
		this.bbsReadCnt = bbsReadCnt;
	}

	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
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


}
