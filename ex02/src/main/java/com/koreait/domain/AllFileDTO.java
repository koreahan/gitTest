package com.koreait.domain;

import java.util.List;

import lombok.Data;

@Data
public class AllFileDTO {
	List<BoardAttachVO> succeedList;
	List<BoardAttachVO> failureList;
}
