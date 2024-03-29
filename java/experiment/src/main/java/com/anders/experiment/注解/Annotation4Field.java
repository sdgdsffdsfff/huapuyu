package com.anders.experiment.注解;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 字段的注解
 * 
 * @author Anders
 * 
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Annotation4Field {
	public String myField();

	public boolean isTrue();
}
