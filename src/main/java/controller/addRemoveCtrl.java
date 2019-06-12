package controller;

import domain.Connect2DB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

public class addRemoveCtrl extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("user");
        String clanId = request.getParameter("clanId");

        String applied = request.getParameter("applied");
        String action = request.getParameter("action");

        Connect2DB c2d = new Connect2DB();
        Connection con = c2d.connect2DB();
        try{
            CallableStatement cs = null;
            if(action.equals("remove")){


                cs = con.prepareCall("{ call deleteUser(?,?)}");
                cs.setString(1,applied);
                cs.setInt(2,Integer.parseInt(clanId));
                cs.execute();

                request.setAttribute("user" , user);
                request.setAttribute("clanId" , clanId);
                request.getRequestDispatcher("MainMenu.jsp").forward(request, response);

            }
            else if(action.equals("add")){

                cs = con.prepareCall("{? = call userHasClan(?)}");
                cs.registerOutParameter(1,Types.INTEGER);
                cs.setString(2,applied);
                cs.execute();

                if(cs.getInt(1) == 1){      // user has a clan
                    request.setAttribute("ARmsg","user has a clan");
                    request.setAttribute("user" , user);
                    request.setAttribute("clanId" , clanId);
                    request.getRequestDispatcher("MainMenu.jsp").forward(request, response);
                }
                else {
                    cs = con.prepareCall("{call addUser(?, ?,?, ?)}");
                    int ind = 0;
                    cs.setInt(++ind, Integer.parseInt(clanId));
                    cs.setString(++ind,applied);
                    cs.setInt(++ind, 1);
                    cs.setInt(++ind, 1); // ROLE IS ADMIN
                    cs.execute();
                    request.setAttribute("user", user);
                    request.setAttribute("clanId", clanId);
                    request.getRequestDispatcher("MainMenu.jsp").forward(request, response);
                }
            }
            else{
                cs = con.prepareCall("{call setRole(?,?)}");
                cs.setString(1,applied);
                cs.setInt(2,Integer.parseInt(request.getParameter("convert")));
                cs.execute();

                request.setAttribute("user" , user);
                request.setAttribute("clanId" , clanId);
                request.getRequestDispatcher("MainMenu.jsp").forward(request, response);
            }


        }catch (Exception e){
            System.out.println(e.getClass().getName() + ": " + e.getMessage());
        }
    }
}