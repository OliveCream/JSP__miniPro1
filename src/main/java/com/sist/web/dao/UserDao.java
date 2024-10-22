package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;
import com.sist.web.model.Board;
import com.sist.web.model.User;

public class UserDao {
	
	private static Logger logger = LogManager.getLogger(UserDao.class);
	
	// 파라미터 userId가 DB에 있으면 PRO_USER테이블 에있는 데이터들 중  USER_ID가 파라미터(userId)에 해당하는 데이터를 User객체 타입의 user에 담아서 반환 
	public User userSelect(String userId) {
		
		User user = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append(" SELECT USER_ID, "
				 + "        NVL(USER_PWD, '') USER_PWD, "
				 + "        NVL(USER_NAME, '') USER_NAME, "
				 + "        NVL(USER_EMAIL, '') USER_EMAIL, "
				 + "        NVL(STATUS, '') STATUS, "
				 + "        NVL(TO_CHAR(REG_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') REG_DATE "
				 + " FROM PRO_USER "
				 + " WHERE USER_ID = ?  ");
 
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, userId);
			
			rs = pstmt.executeQuery();	
			
			if(rs.next()) {
				user = new User();
				user.setUserId(rs.getString("USER_ID"));
				user.setUserPwd(rs.getString("USER_PWD"));
				user.setUserName(rs.getString("USER_NAME"));
				user.setUserEmail(rs.getString("USER_EMAIL"));
				user.setStatus(rs.getString("STATUS"));
				user.setRegDate(rs.getString("REG_DATE"));
			}
		}
		catch(Exception e) {
			logger.error("[userSelect] SQLException : ", e);
		}
		finally {
			DBManager.close(rs, pstmt, conn);
		}
		return user;
	}
	
	
	// 아이디 DB에 있는지 확인 -----------------------------------------------------------------------------------------
	public int userSelectCount(String userId) {
		
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append(" SELECT COUNT(USER_ID) USER_CNT "
				  + "FROM PRO_USER "
				  + "WHERE USER_ID = ? ");
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, userId);
			
			rs = pstmt.executeQuery();		// 쿼리의 결과값이 즉, SELECT의 결과가 String이기때문에 사용해준다.
			
			if(rs.next()) {
				count = rs.getInt("USER_CNT");
			}
			
		}
		catch(Exception e) {
			logger.error("[userSelectCount] SQLException] : ", e);
		}
		finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	
	// 회원 등록 ------------------------------------------------------------------------------------------------------
	public int userInsert(User user) {
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append(" INSERT INTO PRO_USER(USER_ID, USER_PWD, USER_NAME, USER_EMAIL, STATUS, REG_DATE) "
				 + " VALUES(?, ?, ?, ?, ?, SYSDATE) ");	
		
		try {
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, user.getUserId());
			pstmt.setString(++idx, user.getUserPwd());
			pstmt.setString(++idx, user.getUserName());
			pstmt.setString(++idx, user.getUserEmail());
			pstmt.setString(++idx, user.getStatus());
			
			count = pstmt.executeUpdate();
			
		}
		catch(Exception e){
			logger.error("[userDao] userInsert : ", e);
		}
		finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	
	// 회원 정보 수정 ----------------------------------------------------------------------------------------------------
	public int userUpdate(User user) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append( "UPDATE PRO_USER "
				  + "SET "
				  + "USER_NAME = ?, "
				  + "USER_PWD = ?, "
				  + "USER_EMAIL = ? "
				  + "WHERE "
				  + "USER_ID = ? ");
		
		try {
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, user.getUserName());
			pstmt.setString(++idx, user.getUserPwd());
			pstmt.setString(++idx, user.getUserEmail());
			pstmt.setString(++idx, user.getUserId());
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e) {
			logger.error("[UserDao] userUpdate SQLExcetion : ", e);
		}
		finally {
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	
	// 마이페이지 - 본인 게시물 조회
	public List<Board> myBoardList(String userId){
		List<Board> list = new ArrayList<Board>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		ResultSet rs = null;
		
		sql.append("SELECT NVL(BBS_SEQ, 0) AS BBS_SEQ,");
		sql.append("       NVL(USER_ID, '') AS USER_ID,");
		sql.append("       NVL(BBS_NAME, '') AS BBS_NAME,");
		sql.append("       NVL(BBS_TITLE, '') AS BBS_TITLE,");
		sql.append("       NVL(BBS_CONTENT, '') AS BBS_CONTENT,");
		sql.append("       NVL(BBS_READ_CNT, 0) AS BBS_READ_CNT,");
		sql.append("       NVL(TO_CHAR(REG_DATE, 'YYYY-MM-DD HH24:MI:SS'), '') AS REG_DATE");
		sql.append("  FROM PRO_BOARD");
		if(userId != null) {
			sql.append(" WHERE USER_ID = ?");
		}
		sql.append(" ORDER BY BBS_SEQ DESC");

		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Board board = new Board();
				board.setBbsSeq(rs.getLong(("BBS_SEQ")));
				board.setUserId(rs.getString("USER_ID"));
				board.setBbsName(rs.getString("BBS_NAME"));
				board.setBbsTitle(rs.getString("BBS_TITLE"));
				board.setBbsContent(rs.getString("BBS_CONTENT"));
				board.setBbsReadCnt(rs.getInt("BBS_READ_CNT"));
				board.setRegDate(rs.getString("REG_DATE"));
				
				list.add(board);
			}
		}
		catch(Exception e) {
			logger.error("[UserDao] myBoardList SQLExcetion : ", e);
		}
		finally {
			DBManager.close(pstmt, conn);
		}
		
		return list;
	}
	
	// 본인 게시물 조회 (갯수)
	public int myBoardListCnt(String userId) {
		
		int cnt = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		ResultSet rs = null;
		
			sql.append("SELECT COUNT(BBS_SEQ) AS CNT");
			sql.append("  FROM PRO_BOARD");
		if(userId != null) {
			sql.append(" WHERE USER_ID = ?");
		}
		
		try {
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			if(userId != null) {
				pstmt.setString(1, userId);
			}
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				cnt = rs.getInt("CNT");
			}
		}
		catch(Exception e) {
			logger.error("[UserDao] myBoardListCnt : ", e);
		}
		finally {
			DBManager.close(rs, pstmt, conn);
		}
		
		
		return cnt;
	}
	
}
