/**
 * Site Configuration
 * 
 * This file contains all client-specific configuration for the Table Pilot app.
 * To duplicate this site for a new client:
 * 1. Update the values in this file
 * 2. Replace assets in /public/brand/ folder
 * 3. Update environment variables (see .env.example)
 * 4. Update Supabase configuration
 */

export const siteConfig = {
  // ============================================
  // BUSINESS INFORMATION
  // ============================================
  business: {
    name: "Amici Coffee",
    // Short name/acronym shown in logo badge (e.g., "AC" for Amici Coffee)
    logoText: "AC",
    // Optional: tagline or description
    tagline: "Restaurant Table Bookings",
    // Business and restaurant IDs (from Supabase)
    businessId: "24e2799f-60d5-4e3b-bb30-b8049c9ae56d",
    restaurantId: "24e2799f-60d5-4e3b-bb30-b8049c9ae56d",
  },

  // ============================================
  // BRANDING & THEME
  // ============================================
  branding: {
    // Primary brand colors (Tailwind color names)
    // Used for buttons, highlights, and accents throughout the app
    colors: {
      primary: "amber",      // Main brand color
      primaryShade: "600",   // Default shade (400-900)
      hover: "700",          // Hover state shade
      light: "300",          // Light accent shade
      lighter: "500",        // Badge/icon shade
      background: "amber",   // Hero background gradient color
      backgroundShade: "50",
      backgroundTo: "orange",
      backgroundToShade: "100",
    },
    
    // Asset paths (relative to /public)
    assets: {
      favicon: "/brand/favicon.ico",
      logo: "/brand/logo.png",              // Optional: full logo image
      heroImage: "/brand/hero.jpg",         // Optional: default hero image
      ogImage: "/brand/og-image.png",       // Optional: Open Graph/social share image
    },
  },

  // ============================================
  // CONTACT & LOCATION
  // ============================================
  contact: {
    phone: "+44 20 7946 0958",
    email: "info@amicicoffee.com",
    address: "123 Fine Dining Street, Downtown District",
  },

  // ============================================
  // OPERATING HOURS
  // ============================================
  hours: {
    display: "Daily: 8:00 AM - 10:00 PM",
    lastBooking: "9:00 PM",
    // Optional: Add structured hours for future use
    // schedule: {
    //   monday: { open: "08:00", close: "22:00" },
    //   tuesday: { open: "08:00", close: "22:00" },
    //   ...
    // }
  },

  // ============================================
  // SEO & META TAGS
  // ============================================
  seo: {
    title: "Amici Coffee - Restaurant Table Bookings",
    description: "Book your table with Amici Coffee. Experience seamless restaurant bookings with our intuitive booking system.",
    keywords: "restaurant, booking, table reservation, dining, coffee, italian",
    author: "Amici Coffee",
    
    // Open Graph (Facebook, LinkedIn, etc.)
    og: {
      type: "website",
      image: "https://lovable.dev/opengraph-image-p98pqg.png",
    },
    
    // Twitter
    twitter: {
      card: "summary_large_image",
      site: "@tablepilot",
    },
  },

  // ============================================
  // URLS & ROUTING
  // ============================================
  urls: {
    // Production domain (without protocol)
    domain: "tablepilot.co.uk",
    // Base path for the app (e.g., "/amicicoffee" or "/" for root)
    basePath: "/amicicoffee",
    // Full production URL
    productionUrl: "https://tablepilot.co.uk/amicicoffee/",
    // Subdomain (if applicable)
    subdomain: "amicicoffee.tablepilot.co.uk",
  },

  // ============================================
  // FEATURES & COPY
  // ============================================
  features: {
    // Hero section copy
    hero: {
      welcome: "Welcome to",  // "Welcome to {business.name}"
      subtitle: "Experience the perfect blend of Italian tradition and modern comfort. Book your table today and enjoy our authentic coffee and cuisine.",
      ctaText: "Book a Table",
    },
    
    // Feature cards displayed on home page
    cards: [
      {
        icon: "Calendar",
        title: "Easy Booking",
        description: "Book your table in seconds",
      },
      {
        icon: "Users",
        title: "Group Friendly",
        description: "Perfect for any party size",
      },
      {
        icon: "Clock",
        title: "Flexible Times",
        description: "Choose your preferred time",
      },
      {
        icon: "Star",
        title: "Premium Service",
        description: "Exceptional dining experience",
      },
    ],
    
    // Restaurant info section
    info: {
      heading: "Visit {name}",  // {name} will be replaced with business name
      bookingNote: "Booking slots available every 30 minutes",
    },

    // Default restaurant data (used in RestaurantContext)
    defaultRestaurant: {
      id: "24e2799f-60d5-4e3b-bb30-b8049c9ae56d",
      name: "Amici Coffee",
      address: "123 Fine Dining Street, Downtown District",
      cuisine: "Coffee & Dining",
      rating: 4.8,
      imageUrl: "/brand/hero.jpg",
    },
  },

  // ============================================
  // EMAIL CONFIGURATION
  // ============================================
  email: {
    // Default "from" name for booking confirmations
    // Actual email address is set in Supabase secrets (RESEND_FROM)
    fromName: "Amici Coffee",
    defaultFromEmail: "onboarding@resend.dev",  // Fallback only
  },

  // ============================================
  // ELEVENLABS WIDGET (if applicable)
  // ============================================
  elevenLabs: {
    enabled: true,
    agentId: "hFhNyzsEj0QwywLVdOEQ",
  },
} as const;

// ============================================
// HELPER FUNCTIONS
// ============================================

/**
 * Get Tailwind class for primary color
 */
export function getPrimaryColorClass(type: 'bg' | 'text' | 'border' = 'bg', shade?: string): string {
  const { primary, primaryShade } = siteConfig.branding.colors;
  const actualShade = shade || primaryShade;
  return `${type}-${primary}-${actualShade}`;
}

/**
 * Get Tailwind class for hover state
 */
export function getHoverColorClass(type: 'bg' | 'text' | 'border' = 'bg'): string {
  const { primary, hover } = siteConfig.branding.colors;
  return `hover:${type}-${primary}-${hover}`;
}

/**
 * Replace placeholders in text (e.g., "{name}" with business name)
 */
export function replaceTokens(text: string, tokens: Record<string, string> = {}): string {
  let result = text;
  const defaultTokens = {
    name: siteConfig.business.name,
    ...tokens,
  };
  
  Object.entries(defaultTokens).forEach(([key, value]) => {
    result = result.replace(new RegExp(`\\{${key}\\}`, 'g'), value);
  });
  
  return result;
}
