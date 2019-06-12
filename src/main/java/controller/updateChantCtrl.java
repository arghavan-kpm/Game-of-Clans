package controller;

import domain.Connect2DB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

public class updateChantCtrl extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String newChant = request.getParameter("newChant");
        String user = request.getParameter("user");
        String clanId = request.getParameter("clanId");
        Connect2DB c2d = new Connect2DB();

        try{
            Connection con = c2d.connect2DB();
            CallableStatement cs = null;

            cs = con.prepareCall("{ call updateChant(?,?)}");
            cs.setString(1,newChant);
            cs.setInt(2,Integer.parseInt(clanId));
            cs.execute();

            request.setAttribute("user" , user);
            request.setAttribute("clanId" , clanId);
            request.getRequestDispatcher("MainMenu.jsp").forward(request, response);

        }catch (Exception e){
            System.out.println( e.getClass().getName() + ": " + e.getMessage() );
        }

    }
}