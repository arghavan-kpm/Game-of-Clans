package controller;

import domain.Connect2DB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

public class activityCtrl extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connect2DB c2d = new Connect2DB();
        try {
            Connection con = c2d.connect2DB();
            String user = request.getParameter("user");
            String clanId = request.getParameter("clanId");
            String activeId = request.getParameter("activeId");
            String buildingId = request.getParameter("buildingId");

            CallableStatement cs = null;

            if(activeId.equals(buildingId)){        //deactivate the active building

                cs = con.prepareCall("{ call deActive(?)}");
                cs.setInt(1,Integer.parseInt(buildingId));
                cs.execute();

                request.setAttribute("user" , user);
                request.setAttribute("clanId" , clanId);
                request.getRequestDispatcher("MainMenu.jsp").forward(request, response);

            }

            else{
                cs = con.prepareCall("{ call deActive(?)}");
                cs.setInt(1,Integer.parseInt(activeId));
                cs.execute();

                cs = con.prepareCall("{ call activeBuilding(?,?)}");
                cs.setInt(1,Integer.parseInt(buildingId));
                cs.setInt(2,Integer.parseInt(clanId));
                cs.execute();

                request.setAttribute("user" , user);
                request.setAttribute("clanId" , clanId);
                request.getRequestDispatcher("MainMenu.jsp").forward(request, response);
            }


        } catch (Exception e) {
            System.out.println( e.getClass().getName() + ": " + e.getMessage() );
        }
    }
}
