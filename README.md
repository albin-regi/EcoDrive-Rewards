ABSTRACT:
EcoDrive is a comprehensive eco-driving solution developed to promote sustainable transportation through real-time data analytics, intelligent feedback, and an integrated digital platform. The core of the system is a MATLAB-based application that collects essential driving data—including trip distance, speed, acceleration, and fuel consumption—to compute key metrics such as CO₂ emissions and a driving efficiency score. By leveraging advanced algorithms, including real-time route planning via the OSRM API and fallback methods like the Haversine formula, EcoDrive ensures accurate measurement of travel parameters even under varying driving conditions. Simulated driving behavior further refines the analysis by capturing acceleration, deceleration, and idling events, providing a robust assessment of eco-driving performance.

Complementing the MATLAB application, EcoDrive extends its functionality through a dedicated website that serves as an interactive portal for users. The website presents detailed trip summaries, historical data, and analytical visualizations in an intuitive dashboard format. Users can access interactive maps, view various performance graphs—such as speed vs time, acceleration vs time, and speed vs distance—and download comprehensive reports for further analysis. This dual-platform approach not only increases accessibility but also enables remote monitoring and data sharing, making EcoDrive an attractive solution for both individual drivers and fleet managers.

A key innovation of EcoDrive is its reward system, which incentivizes eco-friendly driving by converting driving efficiency into tangible benefits. Reward points are calculated using a formula that considers both the distance traveled and CO₂ emissions, ensuring that even drivers with higher emissions on longer trips can earn rewards. Additional security is provided through an OTP generation feature for safe reward collection, and users receive personalized eco-driving tips tailored to their specific driving patterns.

EcoDrive represents a forward-thinking convergence of engineering, data science, and web technologies, offering a scalable and user-friendly solution for sustainable transportation. The project not only demonstrates the capabilities of MATLAB in advanced analytics and visualization but also emphasizes the importance of integrating modern web interfaces to enhance user engagement and accessibility. Ultimately, EcoDrive lays the groundwork for future innovations in intelligent transportation systems, with potential applications in fleet management, smart city infrastructure, and beyond.

TABLE OF CONTENTS:

Project Structure
Key Files
Features
Installation and Setup
Usage
Reward System
Future Enhancements
License
Contact
PROJECT STRUCTURE:
EcoDrive/

EcoDriveApp.m (Main MATLAB App Designer file)
EcoDrive_Advanced_Backend.m (Backend script for calculations)
EcoDrive_Demo.m (Optional demo or testing script)
playground-1.mongodb.js (Optional file related to database or config)
web/ (Website files, if applicable)
README.md (This file)
KEY FILES:
EcoDriveApp.m

Main UI and callback functions in MATLAB App Designer.
EcoDrive_Advanced_Backend.m

Handles route calculations, CO₂ emission computation, driving score logic, and reward formula.
EcoDrive_Demo.m

Optional file for demonstrating or testing certain parts of the system.
web/

Contains website front-end code (HTML, CSS, JS) for a browser-based dashboard and historical data visualization.
FEATURES:

Real-Time Data Analytics: Gathers driving metrics and computes CO₂ emissions, fuel consumption, and a driving score.
Interactive Visualization: Animated route maps, graphs (speed vs time, acceleration vs time, speed vs distance), and downloadable reports.
Reward System: Calculates reward points based on distance and CO₂ emissions, incentivizing efficient driving.
Personalized Eco-Tips: Offers suggestions for improving fuel efficiency and lowering emissions.
Dual-Platform Accessibility: Combines a MATLAB application with a website, allowing remote data sharing and extended engagement.
INSTALLATION AND SETUP:

Clone or download this repository.
Open MATLAB and navigate to the EcoDrive folder.
Launch EcoDriveApp.m in MATLAB App Designer if you want to view or modify the UI.
(Optional) Serve or deploy the web/ folder to access the online dashboard.
Ensure you have an internet connection for OSRM API calls or rely on the Haversine formula fallback.
USAGE:

Run the MATLAB App by typing:
app = EcoDriveApp;
Enter Trip Details (start and end coordinates, vehicle info).
Click "Calculate Impact" to view distance, CO₂ emissions, driving score, and reward points.
Use "Show Graphs" to view speed vs time, acceleration vs time, speed vs distance, and a bar chart summary.
Click "Collect Rewards" to transfer earned points via OTP.
Explore the website (if applicable) for historical data, comparisons, and additional visualizations.
REWARD SYSTEM:
reward_points = max(0, round(0.3 * distance_km - 0.2 * co2_emissions));

This formula ensures that even drivers with higher emissions on longer trips can still earn rewards.
Users receive an OTP for secure reward redemption.
FUTURE ENHANCEMENTS:

IoT Integration: Collect data directly from OBD-II or connected vehicle sensors.
Machine Learning: Predictive analytics for more accurate emissions modeling and personalized driving suggestions.
Mobile App: Native Android or iOS application for on-the-go usage.
Fleet Management: Scale for multiple drivers and centralized dashboards.
Gamification: Leaderboards and challenges to encourage friendly competition.


CONTACT:
Author: ALBIN REGI
Email: albinregi19@gmail.com
GitHub: https://github.com/albin-regi
