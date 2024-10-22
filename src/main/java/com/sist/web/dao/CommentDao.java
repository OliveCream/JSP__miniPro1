package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;
import com.sist.web.model.Comment;

public class CommentDao {
	
	private static Logger logger = LogManager.getLogger(CommentDao.class);
	
	// 게시물에 해당하는 댓글 조회 메서드
	public List<Comment> commentList(Comment search){
		List<Comment> list = new ArrayList<Comment>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT CCS_SEQ, ");
		sql.append("       BBS_SEQ, ");
		sql.append("       NVL(USER_ID, '') AS USER_ID, ");
		sql.append("       NVL(CCS_NAME, '') AS CCS_NAME, ");
		sql.append("       NVL(CCS_CONTENT, '') AS CCS_CONTENT, ");
		sql.append("       NVL(TO_CHAR(REG_DATE, 'YY.MM.DD HH24:MI'), '') AS REG_DATE ");
		sql.append("FROM PRO_COMMENT ");
		sql.append("WHERE 1=1 ");
		sql.append("AND BBS_SEQ = ? ");
		sql.append("ORDER BY CCS_SEQ DESC ");
		
		try {
			
			conn = DBManager.getConnection();

			
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, search.getBbsSeq());
			rs = pstmt.executeQuery();
			
			Comment comment = null;
			while(rs.next()) {
				comment = new Comment();
				
				comment.setCcsSeq(rs.getLong("CCS_SEQ"));
				comment.setBbsSeq(rs.getLong("BBS_SEQ"));
				comment.setUserId(rs.getString("USER_ID"));
				comment.setCcsName(rs.getString("CCS_NAME"));
				comment.setCcsContent(rs.getString("CCS_CONTENT"));
				comment.setRegDate(rs.getString("REG_DATE"));
				
				list.add(comment);
			}
		}
		catch(Exception e) {
			logger.error("[CommentDao] commentList SQLException", e);
		}
		finally {
			DBManager.close(null, pstmt, conn);
		}


		return list;
	}
	
	// 댓글 등록 메서드
	public int commentInsert(Comment comment) {
		int count = 0;
		long ccsSeq = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("INSERT INTO PRO_COMMENT  ");
		sql.append("(CCS_SEQ, BBS_SEQ, USER_ID, CCS_NAME, CCS_CONTENT, REG_DATE) ");
		sql.append("VALUES (?, ?, ?, ?, ?, SYSDATE) ");
		
		try {
			int idx = 0;
			
			conn = DBManager.getConnection();
			
			ccsSeq = newCcsSeq(conn);
			comment.setCcsSeq(ccsSeq);
			
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(++idx, comment.getCcsSeq());
			pstmt.setLong(++idx, comment.getBbsSeq());
			pstmt.setString(++idx, comment.getUserId());
			pstmt.setString(++idx, comment.getCcsName());
			pstmt.setString(++idx, comment.getCcsContent());
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e) {
			logger.error("[CommentDao] commentInsert SQLException", e);
		}
		finally {
			DBManager.close(null, pstmt, conn);
		}
		
		return count;
	}
	
	// 댓글 시퀀스 조회 메서드
	private long newCcsSeq(Connection conn) {
			long ccsSeq = 0;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			StringBuilder sql = new StringBuilder();
			
			sql.append("SELECT SEQ_PRO_COMMENT_SEQ.NEXTVAL FROM DUAL ");
			
			try {
				pstmt = conn.prepareStatement(sql.toString());
				
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					ccsSeq = rs.getLong(1);
				}
			}
			catch(Exception e) {
				logger.error("[CommentDao] newCcsSeq SQLException - ", e);
			}
			finally {
				DBManager.close(rs, pstmt);	
			}
			
			return ccsSeq;
		}
	
	// 댓글 조회 1건 메서드
	public Comment commentSelect(long ccsSeq) {
		Comment comment = null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs =null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT CCS_SEQ, ");
		sql.append("       BBS_SEQ, ");
		sql.append("       NVL(USER_ID, '') AS USER_ID, ");
		sql.append("       NVL(CCS_NAME, '') AS CCS_NAME, ");
		sql.append("       NVL(CCS_CONTENT, '') AS CCS_CONTENT, ");
		sql.append("       NVL(TO_CHAR(REG_DATE, 'YY.MM.DD HH24:MI'), '') AS REG_DATE ");
		sql.append("FROM PRO_COMMENT ");
		sql.append("WHERE 1=1 ");
		sql.append("AND CCS_SEQ = ? ");
		sql.append("ORDER BY CCS_SEQ DESC ");
		
		try {
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, ccsSeq);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				comment = new Comment();
				
				comment.setBbsSeq(rs.getLong("BBS_SEQ"));
				comment.setUserId(rs.getString("USER_ID"));
				comment.setCcsName(rs.getString("CCS_NAME"));
				comment.setCcsContent(rs.getString("CCS_CONTENT"));
				comment.setRegDate(rs.getString("REG_DATE"));
				
			}
		}
		catch(Exception e) {
			logger.error("[CommentDao] commentSelect SQLException", e);
		}
		finally {
			DBManager.close(rs, pstmt, conn);
		}
		
		return comment;
	}
	
	
	// 댓글 삭제 메서드
	public int commentDelete(long ccsSeq) {
		int count = 0 ;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("DELETE FROM PRO_COMMENT WHERE CCS_SEQ = ? ");
		
		try {
			int idx = 0;
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, ccsSeq);
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e) {
			logger.error("[CommentDao] commentDelete SQLException - ", e);
		}
		finally {
			DBManager.close(null, pstmt, conn);
		}
		
		
		return count;
	}
	
}
