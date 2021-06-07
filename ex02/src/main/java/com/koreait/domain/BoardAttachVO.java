package com.koreait.domain;

import lombok.Data;

//	UUID VARCHAR2(200) NOT NULL,
//	UPLOADPATH VARCHAR2(200) NOT NULL,
//	FILENAME VARCHAR2(200) NOT NULL,
//	FILETYPE CHAR(1) CHECK(FILETYPE IN(0, 1)),
//	BNO NUMBER(10, 0)
@Data
public class BoardAttachVO {
	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean fileType;
	private Long bno;
}
