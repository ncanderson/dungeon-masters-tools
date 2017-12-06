package nate.anderson.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import nate.anderson.dao.inter.RandomTownDAO;
import nate.anderson.model.Culture;
import nate.anderson.model.RandomTown;
import nate.anderson.model.Religion;

@Repository
public class JDBCRandomTownDAO implements RandomTownDAO {

	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public JDBCRandomTownDAO (DataSource dataSource)  {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	@Override
	@Transactional
	public String getRandomTown(int population, String regionGuid) {
		
		String callRandomTownFunction = 
				"select * " + 
				"from fn_generate_random_town(?,?)";
		
		SqlRowSet randomTownResults = jdbcTemplate.queryForRowSet(callRandomTownFunction, population, java.util.UUID.fromString(regionGuid)); 
		
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
