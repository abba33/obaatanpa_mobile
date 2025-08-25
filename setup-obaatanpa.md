# 🤱 Obaatanpa - Complete Setup Guide

## 🎯 What We've Built

A comprehensive maternal care platform for Ghana with:

### 🏗️ **Backend API (Node.js + Express + MySQL)**
- **Authentication System** with JWT tokens
- **User Management** for pregnant mothers, new mothers, and admins
- **Hospital Management** with approval workflows
- **Appointment Booking System** with real-time availability
- **Ghanaian Foods Database** with 15+ local foods and nutritional info
- **Nutrition Planning** with trimester-specific recommendations
- **Content Management** for articles and educational resources
- **Admin Dashboard** with comprehensive management tools
- **Chat System** for expert consultations

### 🎨 **Frontend (Next.js + React + TypeScript)**
- **Modern UI** with Tailwind CSS and dark mode support
- **Responsive Design** optimized for mobile and desktop
- **Authentication Flow** with role-based dashboards
- **API Integration** with custom hooks and type safety
- **Admin Panel** with user, hospital, and content management
- **Ghanaian Cultural Elements** throughout the design

---

## 🚀 Quick Setup

### 1. **Backend Setup**

```bash
# Navigate to backend
cd obaa-backend

# Install dependencies
npm install

# Set up environment
cp .env.example .env
# Edit .env with your MySQL credentials

# Set up database and seed data
npm run setup

# Start backend server
npm run dev
```

**Backend will run on:** `http://localhost:5000`

### 2. **Frontend Setup**

```bash
# Navigate to frontend
cd obaa-new-frontend

# Install dependencies
npm install

# Set up environment
echo "NEXT_PUBLIC_API_URL=http://localhost:5000/api" > .env.local

# Start frontend server
npm run dev
```

**Frontend will run on:** `http://localhost:3000`

---

## 🔑 Test Accounts

After running backend setup, these accounts are available:

### **Admin Account**
- **Email:** `admin@obaatanpa.com`
- **Password:** `admin123`
- **Access:** Full admin dashboard at `/admin`

### **Test User (Pregnant Mother)**
- **Email:** `akosua@example.com`
- **Password:** `password123`
- **Access:** Pregnant mother dashboard

---

## 🏥 Key Features

### **For Pregnant Mothers:**
- ✅ Trimester-specific dashboards (1st, 2nd, 3rd)
- ✅ Hospital search and appointment booking
- ✅ Ghanaian nutrition recommendations
- ✅ Educational content and articles
- ✅ Expert chat consultations
- ✅ Pregnancy tracking tools

### **For New Mothers:**
- ✅ Baby age-specific content (0-6, 6-12 months)
- ✅ Postpartum care resources
- ✅ Breastfeeding support
- ✅ Baby development tracking
- ✅ Pediatric appointment booking

### **For Hospitals:**
- ✅ Registration and verification system
- ✅ Practitioner management
- ✅ Appointment scheduling
- ✅ Patient communication tools

### **For Admins:**
- ✅ User management and analytics
- ✅ Hospital approval workflows
- ✅ Content management system
- ✅ System monitoring and reports

---

## 🇬🇭 Ghanaian Foods Database

### **15+ Local Foods Included:**

#### **Grains & Staples:**
- **Rice (Emo)** - Energy and B vitamins
- **Millet (Acha)** - High iron and protein
- **Corn (Aburo)** - Folate and fiber

#### **Proteins:**
- **Tilapia** - Omega-3 and protein
- **Groundnuts (Nkate)** - Folate and healthy fats
- **Black-eyed Peas (Adua)** - Plant protein and iron

#### **Vegetables:**
- **Kontomire (Cocoyam leaves)** - Very high iron and folate
- **Okra (Nkruma)** - Vitamin C and fiber
- **Garden Egg** - Antioxidants and fiber

#### **Fruits:**
- **Pawpaw (Borɔferɛ)** - Vitamin C and folate
- **Orange (Ankaa)** - Vitamin C and calcium
- **Banana (Kwadu)** - Potassium and B6

#### **Traditional Superfoods:**
- **Tiger Nuts (Atadwe)** - Calcium and protein
- **Coconut (Kube)** - Natural electrolytes
- **Moringa (Zogale)** - Iron, calcium, vitamins

### **Each Food Includes:**
- 🏷️ **Local names** in Ghanaian languages
- 🥗 **Nutritional benefits** and values
- 🤱 **Pregnancy-specific** benefits
- 📅 **Trimester recommendations**
- 👩‍🍳 **Preparation tips** and methods

---

## 🛠️ Technical Architecture

### **Backend Stack:**
- **Node.js** + **Express.js** - Server framework
- **MySQL** - Database with comprehensive schema
- **JWT** - Authentication and authorization
- **bcrypt** - Password hashing
- **Helmet** - Security middleware
- **CORS** - Cross-origin resource sharing

### **Frontend Stack:**
- **Next.js 14** - React framework with App Router
- **TypeScript** - Type safety
- **Tailwind CSS** - Utility-first styling
- **React Hooks** - State management
- **Custom API Client** - Type-safe API integration

### **Database Schema:**
- **users** - User accounts and profiles
- **pregnancy_profiles** - Pregnancy-specific data
- **new_mother_profiles** - Postpartum and baby data
- **hospitals** - Hospital information and services
- **practitioners** - Healthcare providers
- **appointments** - Booking and scheduling
- **ghanaian_foods** - Local foods database
- **nutrition_plans** - Personalized meal planning
- **articles** - Educational content

---

## 📱 API Endpoints

### **Authentication:**
```
POST /api/auth/register     # User registration
POST /api/auth/login        # User login
GET  /api/auth/me          # Get profile
PUT  /api/auth/profile     # Update profile
```

### **Hospitals:**
```
GET  /api/hospitals                    # List hospitals
GET  /api/hospitals/:id               # Get hospital details
GET  /api/hospitals/nearby/:lat/:lng  # Find nearby hospitals
```

### **Appointments:**
```
GET  /api/appointments     # User appointments
POST /api/appointments     # Book appointment
PUT  /api/appointments/:id/cancel # Cancel appointment
```

### **Nutrition:**
```
GET  /api/nutrition/ghanaian-foods      # Get local foods
GET  /api/nutrition/meal-plan           # Personalized meal plan
GET  /api/nutrition/recommendations     # Nutrition advice
```

### **Admin:**
```
GET  /api/admin/dashboard/stats    # Admin statistics
GET  /api/admin/users             # Manage users
PUT  /api/admin/hospitals/:id/status # Approve hospitals
```

---

## 🎨 Frontend Components

### **Key Components Created:**
- **AdminNavbar** - Admin navigation with user management
- **AdminDashboard** - Comprehensive admin overview
- **UserManagement** - User administration interface
- **HospitalManagement** - Hospital approval system
- **GhanaianFoodsSection** - Interactive foods database
- **DownloadAppSection** - App promotion with phone mockups

### **Custom Hooks:**
- **useAuth()** - Authentication management
- **useApi()** - Generic API data fetching
- **useHospitals()** - Hospital data management
- **useAppointments()** - Appointment handling
- **useGhanaianFoods()** - Nutrition data

---

## 🔒 Security Features

### **Backend Security:**
- ✅ **JWT Authentication** with secure tokens
- ✅ **Password Hashing** with bcrypt (12 rounds)
- ✅ **Rate Limiting** to prevent abuse
- ✅ **CORS Configuration** for frontend integration
- ✅ **Input Validation** with express-validator
- ✅ **SQL Injection Prevention** with parameterized queries
- ✅ **Role-based Access Control** (User, Admin)

### **Frontend Security:**
- ✅ **Type Safety** with TypeScript
- ✅ **Secure Token Storage** in localStorage
- ✅ **Protected Routes** with authentication checks
- ✅ **Input Sanitization** on forms
- ✅ **HTTPS Ready** for production

---

## 🚀 Deployment Ready

### **Environment Variables:**
```env
# Backend (.env)
DB_HOST=localhost
DB_NAME=obaatanpa_db
DB_USER=root
DB_PASSWORD=your_password
JWT_SECRET=your_secret_key
PORT=5000

# Frontend (.env.local)
NEXT_PUBLIC_API_URL=http://localhost:5000/api
```

### **Production Checklist:**
- ✅ Database migrations and seeding scripts
- ✅ Environment configuration templates
- ✅ Error handling and logging
- ✅ API documentation and testing
- ✅ Responsive design for all devices
- ✅ Performance optimization
- ✅ Security best practices

---

## 📊 What's Included

### **15+ Database Tables** with complete schema
### **50+ API Endpoints** with full CRUD operations
### **20+ React Components** with modern UI
### **10+ Custom Hooks** for API integration
### **Comprehensive Admin Panel** for system management
### **Ghanaian Cultural Integration** throughout the platform
### **Mobile-First Design** with responsive layouts
### **Dark Mode Support** across all components
### **Type-Safe Development** with TypeScript
### **Production-Ready Architecture** with best practices

---

## 🎯 Next Steps

1. **Start both servers** (backend on :5000, frontend on :3000)
2. **Test the admin panel** at `/admin` with admin credentials
3. **Explore the API** with the provided endpoints
4. **Customize the design** with your branding
5. **Add more Ghanaian foods** to the database
6. **Deploy to production** with your preferred hosting

---

**🇬🇭 Obaatanpa - Supporting Ghanaian Mothers Through Technology 💕**

*Built with love for the mothers of Ghana* 🤱
