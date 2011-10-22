package com.anders.ssh.model.xml;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

public class Resource implements Serializable {
	private static final long serialVersionUID = -8246262126931423368L;

	private Integer id;
	private String name;
	private String content;
	private Boolean enable = true;
	private Set<Role> roles = new HashSet<Role>(0);

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Boolean getEnable() {
		return enable;
	}

	public void setEnable(Boolean enable) {
		this.enable = enable;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Set<Role> getRoles() {
		return roles;
	}

	public void setRoles(Set<Role> roles) {
		this.roles = roles;
	}

}
