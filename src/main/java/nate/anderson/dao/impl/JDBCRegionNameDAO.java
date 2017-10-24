package nate.anderson.dao.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import nate.anderson.dao.inter.RegionNameDAO;
import nate.anderson.model.RegionName;

@Repository
public class JDBCRegionNameDAO implements RegionNameDAO {

	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public JDBCRegionNameDAO (DataSource dataSource)  {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	@Override
	@Transactional
	public List<RegionName> getRegionNames() {
	
		String getAllEntities = 
				"select *"
				+ "from entity_Entity;";
				
		SqlRowSet results = jdbcTemplate.queryForRowSet(getAllEntities);
		
		return mapResultsToRegionName(results);
	
	}
	
	private List<RegionName> mapResultsToRegionName(SqlRowSet results) {
		
		List<RegionName> regionNameResults = new ArrayList<RegionName>();
		
		while (results.next()) {
			
			RegionName regions = new RegionName();
			
			regions.setGuidEntity((java.util.UUID) results.getObject("guid_entity"));
			regions.setNameEntity(results.getString("name_entity"));
			regions.setGuidEntityType((java.util.UUID) results.getObject("guid_entityType"));
			regions.setGuidTimePeriod((java.util.UUID) results.getObject("guid_timePeriod"));
			
			regionNameResults.add(regions);
		}
		
		return regionNameResults;
	}

}
