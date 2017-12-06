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
			"select " + 
			"	e.guid_entity," + 
			"   ed.value_detail," +
			"   e.guid_timeperiod," +
			"   e.guid_entitytype " + 
			"from entity_entity e " + 
			"join entity_entitydetail ed " + 
			"	on e.guid_entity = ed.guid_entity " +
			"join entity_lu_entitytype et " + 
			"   on et.guid_entitytype = e.guid_entitytype " +
			"where et.name_entitytype = 'Region'";	
				
		SqlRowSet results = jdbcTemplate.queryForRowSet(getAllRegions);
		
		return mapResultsToRegion(results);
	
	}
	
	private List<Region> mapResultsToRegion(SqlRowSet results) {
		
		List<Region> regionResults = new ArrayList<Region>();
		
		while (results.next()) {
			
			Region region = new Region();
			
			region.setGuidEntity((java.util.UUID) results.getObject("guid_entity"));
			region.setNameEntity(results.getString("value_detail"));
			region.setGuidEntityType((java.util.UUID) results.getObject("guid_entityType"));
			region.setGuidTimePeriod((java.util.UUID) results.getObject("guid_timePeriod"));
			
			regionResults.add(region);
		}
		
		return regionResults;
	}

}
