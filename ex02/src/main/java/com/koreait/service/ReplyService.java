package com.koreait.service;

import com.koreait.domain.Criteria;
import com.koreait.domain.ReplyPageDTO;
import com.koreait.domain.ReplyVO;

public interface ReplyService {
	public int register(ReplyVO reply);
	public ReplyVO get(Long rno);
	public int remove(Long rno);
	public int modify(ReplyVO reply);
	public ReplyPageDTO getListWithPaging(Criteria cri, Long bno);
}
