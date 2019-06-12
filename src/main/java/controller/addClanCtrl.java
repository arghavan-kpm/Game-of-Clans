package controller;

import domain.Connect2DB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

public class addClanCtrl extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connect2DB c2d = new Connect2DB();
        try {
            Connection con = c2d.connect2DB();
            String user = request.getParameter("user");

            CallableStatement cs = null;

            cs = con.prepareCall("{? = call addClan()}");
            cs.registerOutParameter(1, Types.INTEGER);
            cs.execute();
            int clanId = cs.getInt(1);

            cs = con.prepareCall("{call addUser(?, ?,?, ?)}");
            int ind = 0;
            cs.setInt(++ind,clanId);
            cs.setString(++ind,user);
            cs.setInt(++ind, 1);
            cs.setInt(++ind, 3); // ROLE IS ADMIN
            cs.execute();


            request.setAttribute("user" , user);
            request.setAttribute("clanId" , String.format("%d",clanId));
            request.getRequestDispatcher("MainMenu.jsp").forward(request, response);

        }catch (Exception e){
            System.out.println( e.getClass().getName() + ": " + e.getMessage() );
        }
    }
}