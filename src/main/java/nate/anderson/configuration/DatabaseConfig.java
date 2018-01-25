package nate.anderson.configuration;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.jdbc.DataSourceBuilder;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.JdbcTemplate;

@Configuration
public class DatabaseConfig {
	
	/**
	 * Sets up the main database connection for the app
	 */
	@Primary
	@Bean(name = "mainDBConnection")
	@ConfigurationProperties(prefix = "spring.datasource")
	public DataSource mainDataSource() {
		return  DataSourceBuilder.create().build();
	}

	@Primary
	@Bean(name = "mainJdbcTemplate")
	public JdbcTemplate mainJdbcTemplate(@Qualifier("mainDBConnection") 
                                              DataSource mainDB) {
		return new JdbcTemplate(mainDB);
	}
	
	/**
	 * Monster builder database connection
	 */
	@Bean(name = "monsterBuilderDBConnection")
	@ConfigurationProperties(prefix = "spring.datasource.monsterBuilder")
	public DataSource monsterBuilderDBConnection() {
		return DataSourceBuilder.create().build();
	}

	@Bean(name = "monsterBuilderJdbcTemplate")
	public JdbcTemplate monsterBuilderJdbcTemplate(@Qualifier("monsterBuilderDBConnection") 
                                              DataSource monsterBuilderDB) {
		return new JdbcTemplate(monsterBuilderDB);
	}

}
