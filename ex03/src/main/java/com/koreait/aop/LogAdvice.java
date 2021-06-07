package com.koreait.aop;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class LogAdvice {
	//AOP를 사용하기 위해서는 종단관심사에 Proxy설정이 되어야 한다.
	//이는 root-context.xml에 auto로 설정을 해놓는다.
	//횡단관심사에서 작성한 모듈은 Proxy설정이 되어 있는 Target(주객체)에게
	//언제 결합해야 되는 지를 알려주어야 하는데, 이를 pointcut이라고 한다.
	//Target(주객체)에 있는 종단관심사가 호출되면 pointcut에 작성된 Target(메소드)
	//의 전체 정보를 가지고 올 수 있는 객체가 바로 JoinPoint(결합되는 지점)이다.
	
	//execution...은 AspectJ의 표현식이며, 맨 앞의 * 은 접근제어자를 의미하고,
	//맨 마지막의 *은 클래스의 이름과 메소드의 이름을 의미한다.
	//..은 0개 이상이라는 의미이다.
	
	//모든 접근 제어자의 SampleService이름이 붙은 모든 클래스에서 모든 메소드 중
	//매개변수가 0개 이상이라는 뜻
	@Before("execution(* com.koreait.service.SampleService*.*(..))")
	public void logBefore() {
		log.info("========Before==========");
	}

	@After("execution(* com.koreait.service.SampleService*.*(..))")
	public void logAfter() {
		log.info("========After==========");
	}

	@AfterReturning("execution(* com.koreait.service.SampleService*.*(..))")
	public void logAfterRetruning() {
		log.info("========AfterReturning==========");
	}
	
	//args(매개변수명, 매개변수명,...)
	//호출된 종단관심사의 매개변수를 횡단관심사로 전달받을 때에는 매개변수의 개수와 타입에 맞게
	//작성해 주어야 하며, args에 해당 매개변수의 이름을 동일하게 작성해주어야 한다.
	@Before("execution(* com.koreait.service.SampleService*.doAdd(String, String)) && args(str1, str2)")
	public void logBeforeWithParam(String str1, String str2) {
		log.info("str1 : " + str1);
		log.info("str2 : " + str2);
	}
	
	//pointcunt은 횡단관심사와 종단관심사의 결합되는 지점을 결정하는 것이다.
	@AfterThrowing(pointcut="execution(* com.koreait.service.SampleService*.*(..))", throwing="exception")
	public void logException(Exception exception) {
		log.info("Exception..........");
		log.info("exception : " + exception);
	}
	
	@Around("execution(* com.koreait.service.SampleService*.*(..))")
	public Object logTime(ProceedingJoinPoint pjp) {
		long start = System.currentTimeMillis();
		
		log.info("핵심 로직 : " + pjp.getTarget());
		log.info("파라미터 : " + Arrays.toString(pjp.getArgs()));
		
		Object result = null;
		
		try {
			result = pjp.proceed();
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		long end = System.currentTimeMillis();
		log.info("걸린 시간 : " + (end - start));
		return result;
	}
}



















