package com.koreait.domain;


import java.util.List;

import lombok.Data;

/*BNO NUMBER(10),
TITLE SVARCHAR2(200) NOT NULL,
CONTENT VARCHAR2(2000) NOT NULL,
WRITER VARCHAR2(200) NOT NULL,
REGDATE DATE DEFAULTS SYSDATE,
UPDATEDATE DATE DEFAULT SYSDATE*/
@Data
public class BoardVO {
	private Long bno;
	private String title;
	private String content;
	private String writer;
	private String regDate;
	private String updateDate;
	private int replyCnt;
	//input태그 name에 attachList[i].filName
	private List<BoardAttachVO> attachList;
}

























