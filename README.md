Ligesa: Digital Charity & QR Donation Platform (Powered by Arifpay)🌟 Project OverviewLigesa is a pioneering digital payment application designed to revolutionize the charity and philanthropy sector in Ethiopia. It provides a seamless, secure, and transparent way for individuals and organizations (such as churches, mosques, and NGOs) to handle cashless donations using QR code technology integrated with the Arifpay financial ecosystem.The goal is to move charitable giving from cash-based, non-transparent systems to an efficient, digital platform, supporting Ethiopia's national push for financial inclusion and digitalization.✨ Unique Value & ImpactLigesa's uniqueness and impact are centered on solving key operational and trust issues in the charity sector:True Cashless Interoperability: Utilizes Arif-QR to accept donations from any major bank app or mobile wallet within the Ethiopian financial network, enabling instantaneous, spontaneous, and cashless giving in any physical location.Enhanced Transparency: Provides beneficiaries with a real-time, digital ledger of all funds received, dramatically improving accountability and fostering greater donor trust.Diaspora Connection: Offers a reliable and secure digital channel for the Ethiopian diaspora to contribute directly to local, trusted community organizations without excessive remittance fees.Digital Economy Driver: Actively supports the "Digital Ethiopia 2030" strategy by driving digital adoption in a traditionally cash-reliant sector.🚀 FeaturesQR Code Generation: Generates unique, interoperable QR codes for each designated donation recipient (e.g., a specific church fund or NGO campaign).Real-Time Transaction Tracking: Donors and recipients can view confirmed donations instantly.Secure Payment Gateway: Utilizes the robust and licensed Arifpay API for secure transaction processing.User Authentication: Secure access control for both administrators and charity beneficiaries.Responsive Mobile App: Built with Flutter for a fast and consistent user experience on both iOS and Android.🛠️ Tech StackBackendTechnologyRoleNode.jsRuntime EnvironmentExpress.jsWeb FrameworkMongoDBNoSQL DatabaseJWTAuthentication & AuthorizationFrontendTechnologyRoleFlutterCross-platform Mobile UI FrameworkDartProgramming Language⚙️ Installation and SetupPrerequisitesYou must have the following installed on your local machine:Node.js (LTS Version) and npm or YarnMongoDB running locally or a cloud connection stringFlutter SDK and necessary IDE/Platform tools (Android Studio/VS Code)1. Backend SetupClone the repository:git clone [Your-Repo-URL]
cd ligesa-backend
Install dependencies:npm install
# or
yarn install
Configure Environment Variables (See the Configuration section below).Start the server:npm run dev
# or
yarn dev
The backend should now be running at http://localhost:5000.2. Frontend Setup (Flutter)Navigate to the frontend directory:cd ../ligesa-frontend
Install dependencies:flutter pub get
Configure Environment Variables (See the Configuration section below). These variables are typically placed in a separate file (e.g., .env or config.dart) depending on your implementation.Run the application:flutter run
🔐 Configuration (Environment Variables)You need to create the respective environment files in your backend (.env in the root) and frontend projects.1. Backend .envCreate a file named .env in your backend root directory:PORT_NUMBER=5000
# Secret key for generating JSON Web Tokens for access control. **CHANGE THIS.**
JWT_TOKEN=YOUR_STRONG_ACCESS_TOKEN_SECRET
JWT_EXPIRATION=1h
# Secret key for generating refresh tokens. **CHANGE THIS.**
JWT_REFRESH_SECRET=YOUR_STRONG_REFRESH_TOKEN_SECRET

# Connection string for your local MongoDB instance.
MONGO_DB_LOCAL="mongodb://localhost:27017/arifpay"

NODE_ENV="development"
2. Flutter App ConfigurationDepending on your Flutter setup (e.g., using flutter_dotenv package), create a configuration file. Note: For security, never commit actual tokens to GitHub. The values below must be masked secrets used by your app.# Example Flutter .env file (or equivalent config.dart)

# Token for the third-party messaging or authentication service (e.g., Africom Message Service  https://www.afromessage.com/).
AFRMESSAGE_TOKEN=YOUR_AFRMESSAGE_TOKEN_HERE

# The official API token required for connecting and processing transactions via the Arifpay payment gateway.
ARIF_PAY_TOKEN=YOUR_ARIF_PAY_LIVE_TOKEN
For any contribution, feature request, or issue, please use the GitHub Issues tracker.