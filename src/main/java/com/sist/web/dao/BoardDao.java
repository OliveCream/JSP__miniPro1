package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.common.util.StringUtil;
import com.sist.web.db.DBManager;
import com.sist.web.model.Board;

public class BoardDao {
	private static Logger logger = LogManager.getLogger(BoardDao.class);
	
	
	// 게시물 리스트 조회 (searchType searchValue) 메서드
	public List<Board> boardList(Board search){
		List<Board> list = new ArrayList<Board>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		
		sql.append(" SELECT ");
		sql.append("         BBS_SEQ, ");
		sql.append("         USER_ID, ");
		sql.append("         BBS_NAME, ");
		sql.append("         USER_EMAIL, ");
		sql.append("         BBS_TITLE, ");
		sql.append("         BBS_CONTENT, ");
		sql.append("         BBS_READ_CNT, ");
		sql.append("         REG_DATE ");
		sql.append(" FROM (  SELECT  ROWNUM RNUM, ");
		sql.append("                 BBS_SEQ, ");
		sql.append("                 USER_ID, ");
		sql.append("                 BBS_NAME, ");
		sql.append("                 USER_EMAIL, ");
		sql.append("                 BBS_TITLE, ");
		sql.append("                 BBS_CONTENT, ");
		sql.append("                 BBS_READ_CNT, ");
		sql.append("                 REG_DATE ");
		sql.append("         FROM (  SELECT B.BBS_SEQ, ");
		sql.append("                        A.USER_ID, ");
		sql.append("                        NVL(B.BBS_NAME, '') BBS_NAME, ");
		sql.append("                        NVL(A.USER_EMAIL, '') USER_EMAIL, ");
		sql.append("                        NVL(B.BBS_TITLE, '') BBS_TITLE, ");
		sql.append("                        NVL(B.BBS_CONTENT, '') BBS_CONTENT, ");
		sql.append("                        NVL(B.BBS_READ_CNT, '') BBS_READ_CNT, ");
		sql.append("                        NVL(TO_CHAR(B.REG_DATE, 'YYYY/MM/DD HH24:MI:SS'), '') REG_DATE ");
		sql.append("                 FROM PRO_USER A, PRO_BOARD B ");
		sql.append("                 WHERE A.USER_ID = B.USER_ID ");
		
		
		if(search != null) {
			if(!StringUtil.isEmpty(search.getBbsName())) {
				sql.append("    AND B.BBS_NAME LIKE '%' || ? || '%' ");		
			}
			if(!StringUtil.isEmpty(search.getBbsTitle())) {
				sql.append("    AND B.BBS_TITLE LIKE '%' || ? || '%' ");
			}
			if(!StringUtil.isEmpty(search.getBbsContent())) {
				sql.append("    AND DBMS_LOB.INSTR(B.BBS_CONTENT, ?) > 0 ");
			}
			if(!StringUtil.isEmpty(search.getBbsTitle())) {
				sql.append("    AND B.BBS_TITLE LIKE '%' || ? || '%' ");
			}
		}
		
		sql.append("            ORDER BY B.BBS_SEQ DESC) ) ");
		
		if(search != null) {
			sql.append("WHERE RNUM >= ? ");
			sql.append("AND RNUM <= ? ");
		}
		
		
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			int idx = 0;
			if(search != null) {
				if(!StringUtil.isEmpty(search.getBbsName())) {
					pstmt.setString(++idx, search.getBbsName());
				}
				if(!StringUtil.isEmpty(search.getBbsTitle())) {
					pstmt.setString(++idx, search.getBbsTitle());
				}
				if(!StringUtil.isEmpty(search.getBbsContent())) {
					pstmt.setString(++idx, search.getBbsContent());
				}
				
				pstmt.setLong(++idx, search.getStartRow());
				pstmt.setLong(++idx, search.getEndRow());
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Board board = new Board();
				board.setBbsSeq(rs.getLong("BBS_SEQ"));
				board.setBbsName(rs.getString("BBS_NAME"));
				board.setUserId(rs.getString("USER_ID"));
				board.setBbsTitle(rs.getString("BBS_TITLE"));
				board.setBbsContent(rs.getString("BBS_CONTENT"));
				board.setBbsReadCnt(rs.getInt("BBS_READ_CNT"));
				board.setRegDate(rs.getString("REG_DATE"));
				
				list.add(board);
			}
			
		}
		catch(Exception e) {
			logger.error("[BoardDao] boardList() SQLException : ", e);
		}
		finally {
			DBManager.close(rs, pstmt, conn);
		}
		
		return list;
	}
	
	
	
	// 게시물 수 조회 메서드 ----------------------------------------------------------
	
	public long boardTotalCount(Board search) {
		long totalCount = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT COUNT(BBS_SEQ) TOTAL_COUNT "); 
		sql.append("FROM PRO_BOARD "); 
		sql.append("WHERE 1=1 "); 
		
		
		if(search != null) {
			if(!StringUtil.isEmpty(search.getBbsName())) {
				sql.append("AND BBS_NAME LIKE '%' || ? || '%' "); 
			}
			if(!StringUtil.isEmpty(search.getBbsTitle())) {
				sql.append("AND BBS_TITLE LIKE '%' || ? || '%' "); 
			}
			if(!StringUtil.isEmpty(search.getBbsContent())) {
				sql.append("AND BBS_CONTENT LIKE '%' || ? || '%' "); 
			}
		}
		
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			int idx = 0;
			if(search != null) {
				if(!StringUtil.isEmpty(search.getBbsName())) {
					pstmt.setString(++idx, search.getBbsName());
				}
				if(!StringUtil.isEmpty(search.getBbsTitle())) {
					pstmt.setString(++idx, search.getBbsTitle());
				}
				if(!StringUtil.isEmpty(search.getBbsContent())) {
					pstmt.setString(++idx, search.getBbsContent());
				}
			}
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				totalCount = rs.getLong("TOTAL_COUNT");
			}
			
		}
		catch(Exception e) {
			logger.error("[BoardDao] boardTotalCount : ", e);
		}
		finally {
			DBManager.close(rs, pstmt, conn);
		}
		
		
		return totalCount;
	}
	
	
	// 게시물 등록 메서드 (view.jsp) - boardInsert() ------------------------------------------------------------------
	public int boardInsert(Board board) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append(" INSERT INTO PRO_BOARD(BBS_SEQ, USER_ID, BBS_NAME, BBS_TITLE, BBS_CONTENT, BBS_READ_CNT, REG_DATE) ");
		sql.append(" VALUES ");
		sql.append(" (?, ?, ?, ?, ?, 0, SYSDATE) ");
		
		try {
			int idx = 0;
			long bbsSeq = 0;
			
			conn = DBManager.getConnection();
			
			bbsSeq = newBbsSeq(conn);
			board.setBbsSeq(bbsSeq);
			
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(++idx, board.getBbsSeq());
			pstmt.setString(++idx, board.getUserId());
			pstmt.setString(++idx, board.getBbsName());
			pstmt.setString(++idx, board.getBbsTitle());
			pstmt.setString(++idx, board.getBbsContent());
			
			count = pstmt.executeUpdate();
			
		}
		catch(Exception e) {
			logger.error("[BoardDao] boardInser SQLException - ", e);
		}
		finally {
			DBManager.close(null, pstmt, conn);
		}
		
		return count;
	}
	
	private long newBbsSeq(Connection conn) {
		long bbsSeq = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT SEQ_PRO_BOARD_SEQ.NEXTVAL FROM DUAL ");
		
		try{
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				bbsSeq = rs.getLong(1);
			}
		}
		catch(Exception e) {
			logger.error("[BoardDao] newBbsSeq SQLException - ", e);
		}
		finally {
			DBManager.close(rs, pstmt);
		}
		
		return bbsSeq;
	}
	
	
	
	
	// view 페이지 게시물 조회 boardSelect() 메서드 -----------------------------------------------------
	public Board boardSelect(long bbsSeq) {
		Board board = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT BBS_SEQ, ");
		sql.append("      USER_ID, ");
		sql.append("       NVL(BBS_NAME, '') AS BBS_NAME, ");
		sql.append("       NVL(BBS_TITLE, '') AS BBS_TITLE, ");
		sql.append("       NVL(BBS_CONTENT, '') AS BBS_CONTENT, ");
		sql.append("       NVL(BBS_READ_CNT, 0) AS BBS_READ_CNT, ");
		sql.append("       NVL(TO_CHAR(REG_DATE, 'YYYY/MM/DD HH24:MI:SS'), '') AS REG_DATE ");
		sql.append("FROM PRO_BOARD ");
		sql.append("WHERE BBS_SEQ = ? ");
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, bbsSeq);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				board = new Board();
				
				board.setBbsSeq(rs.getLong("BBS_SEQ"));
				board.setUserId(rs.getString("USER_ID"));
				board.setBbsName(rs.getString("BBS_NAME"));
				board.setBbsTitle(rs.getString("BBS_TITLE"));
				board.setBbsContent(rs.getString("BBS_CONTENT"));
				board.setBbsReadCnt(rs.getInt("BBS_READ_CNT"));
				board.setRegDate(rs.getString("REG_DATE"));
			}
		}
		catch(Exception e){
			logger.error("[BoardDao] boardSelect - ", e);
		}
		finally {
			DBManager.close(rs, pstmt, conn);
		}
				
		return board;
	}
	
	// 게시물 수정 메서드 boardUpdate
	public int boardUpdate(Board board) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE PRO_BOARD ");
		sql.append("SET BBS_TITLE = ?, ");
		sql.append("    BBS_CONTENT = ? ");
		sql.append("WHERE BBS_SEQ = ? ");
		
		try {
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, board.getBbsTitle());
			pstmt.setString(++idx, board.getBbsContent());
			pstmt.setLong(++idx, board.getBbsSeq());
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e) {
			logger.error("[BoardDao] boardUpdate SQLExeption : ", e);	//디버그말고 에러찍는 이유: 
		}
		finally {
			DBManager.close(pstmt, conn);
		}
		
		
		return count;
	}
	
	
	// 게시물 삭제 메서드
	public int boardDelete(long bbsSeq) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;	
		StringBuilder sql = new StringBuilder();
		
		sql.append("DELETE FROM PRO_BOARD WHERE BBS_SEQ = ? ");
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, bbsSeq);
			count = pstmt.executeUpdate();
		}
		catch(Exception e){
			logger.error("[BoardDoa] boardDelete SQLException : ", e);
		}
		finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	
	
	// 조회수 증가 메서드
	public int boardReadCntPlus(long bbsSeq) {
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("UPDATE PRO_BOARD ");
		sql.append("SET BBS_READ_CNT = BBS_READ_CNT + 1 ");
		sql.append("WHERE BBS_SEQ = ? ");
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, bbsSeq);
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e) {
			logger.error("[BoardDao] boardReadCntPlus SQLException : ", e);
		}
		finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	
	
	
}
