package dao.interf;

import java.util.List;

import model.Tb_user;

public interface ITb_userDao
{
	public Tb_user get(int id);

	public void save(Tb_user model);

	public void update(Tb_user model);

	public void delete(Tb_user model);

	public void deleteById(int id);

	@SuppressWarnings("unchecked")
	public List getAll();
}