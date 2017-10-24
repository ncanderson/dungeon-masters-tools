package nate.anderson.dao.impl;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import nate.anderson.dao.inter.RegionDAO;
import nate.anderson.model.Region;

@Repository
public class JDBCRegionDAO implements RegionDAO {

	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public JDBCRegionDAO (DataSource dataSource)  {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	@Override
	@Transactional
	public List<Region> getAllRegions() {
	
		String getAllRegions = 
				"select * "
				+ "from entity_Entity;";
				
		SqlRowSet results = jdbcTemplate.queryForRowSet(getAllRegions);
		
		return mapResultsToRegion(results);
	
	}
	
	private List<Region> mapResultsToRegion(SqlRowSet results) {
		
		List<Region> regionResults = new ArrayList<Region>();
		
		while (results.next()) {
			
			Region region = new Region();
			
			region.setGuidEntity((java.util.UUID) results.getObject("guid_entity"));
			region.setNameEntity(results.getString("name_entity"));
			region.setGuidEntityType((java.util.UUID) results.getObject("guid_entityType"));
			region.setGuidTimePeriod((java.util.UUID) results.getObject("guid_timePeriod"));
			
			regionResults.add(region);
		}
		
		return regionResults;
	}

}
