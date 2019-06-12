package controller;

import domain.Connect2DB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

public class attackCtrl extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("user");
        String clanId = request.getParameter("clanId");
        String attacked = request.getParameter("attacked");

        Connect2DB c2d = new Connect2DB();
        Connection con = c2d.connect2DB();

        try{
            int e1 = 0,e2 = 0;
            int winner = 0,loser = 0;
            CallableStatement cs = null;

            cs = con.prepareCall("{?= call getExpr(?)}");
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setInt(2,Integer.parseInt(clanId));
            cs.execute();
            e1 = cs.getInt(1);

            cs = con.prepareCall("{?= call getExpr(?)}");
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setInt(2,Integer.parseInt(attacked));
            cs.execute();
            e2 = cs.getInt(1);

            int random = (int)(Math.random() * (e1 + e2 ));
            if(0<= random && random <= e1){
                winner = Integer.parseInt(clanId);
                loser = Integer.parseInt(attacked);
            }
            else{
                loser = Integer.parseInt(clanId);
                winner = Integer.parseInt(attacked);
            }

            cs = con.prepareCall("{ call Attack(?,?)}");
            cs.setInt(1,winner);
            cs.setInt(2,loser);
            cs.execute();

            request.setAttribute("user" , user);
            request.setAttribute("clanId" , clanId);
            request.getRequestDispatcher("MainMenu.jsp").forward(request, response);

        }catch (Exception e){
            System.out.println( e.getClass().getName() + ": " + e.getMessage() );
        }
    }
}