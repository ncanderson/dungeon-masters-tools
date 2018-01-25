package nate.anderson.dao.impl;

import javax.sql.DataSource;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Repository;

import nate.anderson.dao.inter.MonsterBuilderDAO;

@Repository
public class JDBCMonsterBuilderDAO implements MonsterBuilderDAO {

	@Autowired
	@Qualifier("monsterBuilderJdbcTemplate")
	private JdbcTemplate monsterBuilderJdbcTemplate;

	@Autowired
	public JDBCMonsterBuilderDAO (DataSource dataSource)  {
		this.monsterBuilderJdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	@Override
	@Transactional 
	public String getMonsterSizes() {
		
		String getAllSizes = "select * " +
							 "from fn_get_sizes()";
		
		SqlRowSet sizeResults = monsterBuilderJdbcTemplate.queryForRowSet(getAllSizes);
		
		String sizes = "";
		
		while (sizeResults.next()) {
			sizes = sizeResults.getString("fn_get_sizes");
		}
		
		return sizes;
	}

}
