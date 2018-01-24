package nate.anderson.dao.impl;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import nate.anderson.dao.inter.RandomTownDAO;

@Repository
public class JDBCRandomTownDAO implements RandomTownDAO {

	@Autowired
	@Qualifier("mainJdbcTemplate")
	private JdbcTemplate mainJdbcTemplate;

	@Autowired
	public JDBCRandomTownDAO (DataSource dataSource)  {
		this.mainJdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	@Override
	@Transactional
	public String getRandomTown(int population, String regionGuid) {
		
		String callRandomTownFunction = 
				"select * " + 
				"from fn_generate_random_town(?,?)";
		
		SqlRowSet randomTownResults = mainJdbcTemplate.queryForRowSet(callRandomTownFunction, population, java.util.UUID.fromString(regionGuid)); 
		
		return createTownFromResultSet(randomTownResults);
	}

	private String createTownFromResultSet(SqlRowSet results) {

		String randomTown = "";
		
		while (results.next()) {
			
			randomTown = results.getString("fn_generate_random_town");
						
		}
		
		return randomTown;
	}
	
	

}
