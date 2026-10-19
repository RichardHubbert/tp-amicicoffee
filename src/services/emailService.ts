import { format } from 'date-fns';
import { Booking } from './supabaseBookingService';
import { siteConfig } from '@/config/site';
import { supabase } from '@/integrations/supabase/client';

/**
 * Format a booking date and time for display in emails
 */
const formatBookingDateTime = (date: string, time: string): string => {
  const bookingDate = new Date(date);
  const formattedDate = format(bookingDate, 'EEEE, MMMM do, yyyy');
  return `${formattedDate} at ${time}`;
};

/**
 * Send a booking confirmation email via Supabase Edge Function (uses Resend)
 */
export const sendBookingConfirmationEmail = async (booking: Booking): Promise<{ success: boolean; error?: string }> => {
  try {
    console.log('📧 Sending booking confirmation email via Supabase edge function...');
    
    // Format the booking date and time for the email
    const formattedDateTime = formatBookingDateTime(booking.booking_date, booking.start_time);
    
    // Call Supabase edge function (uses Resend with "Table Pilot" sender)
    const { data, error } = await supabase.functions.invoke('send-booking-email', {
      body: {
        to_name: booking.customer_name,
        to_email: booking.customer_email,
        booking_id: booking.id,
        booking_date_time: formattedDateTime,
        party_size: booking.party_size,
        special_requests: booking.special_requests || 'None',
        restaurant_id: booking.restaurant_id || siteConfig.business.restaurantId,
        // Fallback data (edge function will fetch from DB if restaurant_id provided)
        restaurant_name: siteConfig.business.name,
        restaurant_address: siteConfig.contact.address,
        restaurant_phone: siteConfig.contact.phone,
        restaurant_email: siteConfig.contact.email,
      },
    });

    if (error) {
      console.error('❌ Edge function error:', error);
      // Log error but don't expose details to user
      return { success: false, error: 'Email delivery failed' };
    }

    if (data?.error) {
      console.error('❌ Email send failed:', data.error);
      // Log error but don't expose details to user
      return { success: false, error: 'Email delivery failed' };
    }

    console.log('✅ Confirmation email sent successfully');
    return { success: true };
  } catch (error) {
    console.error('❌ Failed to send confirmation email:', error);
    // Log error but don't expose details to user
    return { success: false, error: 'Email delivery failed' };
  }
};

/**
 * Test email service (calls edge function with test data)
 */
export const testEmailService = async (): Promise<{ success: boolean; error?: string }> => {
  try {
    console.log('🧪 Testing email service...');
    
    const { data, error } = await supabase.functions.invoke('send-booking-email', {
      body: {
        to_name: 'Test User',
        to_email: 'test@example.com',
        booking_id: 'TEST-' + Date.now(),
        booking_date_time: format(new Date(), 'EEEE, MMMM do, yyyy') + ' at 19:00',
        party_size: 2,
        special_requests: 'Test booking',
        restaurant_id: siteConfig.business.restaurantId,
        restaurant_name: siteConfig.business.name,
        restaurant_address: siteConfig.contact.address,
        restaurant_phone: siteConfig.contact.phone,
        restaurant_email: siteConfig.contact.email,
      },
    });

    if (error || data?.error) {
      console.error('❌ Email test failed:', error || data?.error);
      return { success: false, error: error?.message || data?.error || 'Test failed' };
    }

    console.log('✅ Email test successful');
    return { success: true };
  } catch (error) {
    console.error('❌ Email test error:', error);
    return { success: false, error: error instanceof Error ? error.message : 'Test failed' };
  }
};
