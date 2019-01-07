package org.baeldung.spring;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
@Profile("!https")
public class SecSecurityConfig extends WebSecurityConfigurerAdapter {
	
	@Autowired
	DataSource dataSource;

    public SecSecurityConfig() {
        super();
    }
    
    @Autowired
    public void configAuthentication(AuthenticationManagerBuilder auth) throws Exception {
        auth.jdbcAuthentication().dataSource(dataSource)
        .usersByUsernameQuery("select username,password, enabled from users where username=?")
        .authoritiesByUsernameQuery("select username, role from users where username=?");
        auth.jdbcAuthentication().dataSource(dataSource)
        .usersByUsernameQuery("select username,password, enabled from admins where username=?")
        .authoritiesByUsernameQuery("select username, role from admins where username=?");
    } 

    @Override
    protected void configure(final HttpSecurity http) throws Exception {
        http
        .csrf().disable()
        .authorizeRequests()
        	.antMatchers("/register*").permitAll()
        	.antMatchers("/admin/**").access("hasRole('ROLE_ADMIN')")
        	.antMatchers("/anonymous*").anonymous()
        	.antMatchers(HttpMethod.GET, "/index*", "/static/**", "/*.js", "/*.json", "/*.ico").permitAll()
        	.anyRequest().authenticated()
        .and()
        	.formLogin()
        	.loginPage("/index.html")
        	.loginProcessingUrl("/perform_login")
        	.defaultSuccessUrl("/homepage.html",true)
        	.failureUrl("/index.html?error=true")
        .and()
        	.logout()
        	.logoutUrl("/perform_logout")
        	.deleteCookies("JSESSIONID");
    }


}
