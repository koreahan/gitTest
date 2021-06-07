package com.koreait.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.koreait.domain.Criteria;
import com.koreait.domain.ReplyVO;

public interface ReplyMapper {
	public int insert(ReplyVO reply);
	public ReplyVO read(Long rno);
	public int delete(Long rno);
	public int update(ReplyVO reply);
	/*
	 * 기존의 게시물 페이징 처리 + 특정 게시물 번호를 전달해야 한다.
	 * MyBatis는 두 개 이상의 데이터를 파라미터로 전달하기 위해서는
	 * 별도의 객체를 구성하거나 Map을 이용, @Param을 이용한다.
	 * */
	public List<ReplyVO> getListWithPaging(@Param("cri") Criteria cri, @Param("bno") Long bno);
	public int getTotal(Long bno);
}














