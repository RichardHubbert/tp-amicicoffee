import React from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Calendar, Users, Clock, Star } from 'lucide-react';

interface HeroSectionProps {
  onBookTable: () => void;
  restaurantName?: string;
  imageUrl?: string;
}

const HeroSection: React.FC<HeroSectionProps> = ({ onBookTable, restaurantName = 'Woodman and Olive', imageUrl }) => {
  const hasImage = Boolean(imageUrl);

  return (
    <section className={`relative overflow-hidden py-20 ${hasImage ? 'min-h-[32rem]' : 'bg-gradient-to-br from-amber-50 to-orange-100'}`}>
      {hasImage && (
        <>
          <img src={imageUrl} alt="" className="absolute inset-0 h-full w-full object-cover" />
          <div className="absolute inset-0 bg-gradient-to-b from-black/55 via-black/45 to-black/65" />
        </>
      )}
      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center">
          <h1 className={`text-4xl md:text-6xl font-bold mb-6 ${hasImage ? 'text-white' : 'text-gray-900'}`}>
            Welcome to{' '}
            <span className={hasImage ? 'text-amber-300' : 'text-amber-600'}>{restaurantName}</span>
          </h1>
          <p className={`text-xl mb-8 max-w-3xl mx-auto ${hasImage ? 'text-white/90' : 'text-gray-600'}`}>
            Book a table at {restaurantName}. Choose your date, time, and party size.
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-8">
            <Button 
              onClick={onBookTable}
              size="lg" 
              className="bg-amber-600 hover:bg-amber-700 text-white px-8 py-3 text-lg"
            >
              Book a Table
            </Button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-4 gap-6 max-w-4xl mx-auto">
            <Card className="text-center">
              <CardContent className="pt-6">
                <Calendar className="h-8 w-8 text-amber-600 mx-auto mb-2" />
                <h3 className="font-semibold text-gray-900">Easy Booking</h3>
                <p className="text-sm text-gray-600">Book your table in seconds</p>
              </CardContent>
            </Card>
            
            <Card className="text-center">
              <CardContent className="pt-6">
                <Users className="h-8 w-8 text-amber-600 mx-auto mb-2" />
                <h3 className="font-semibold text-gray-900">Group Friendly</h3>
                <p className="text-sm text-gray-600">Perfect for any party size</p>
              </CardContent>
            </Card>
            
            <Card className="text-center">
              <CardContent className="pt-6">
                <Clock className="h-8 w-8 text-amber-600 mx-auto mb-2" />
                <h3 className="font-semibold text-gray-900">Flexible Times</h3>
                <p className="text-sm text-gray-600">Choose your preferred time</p>
              </CardContent>
            </Card>
            
            <Card className="text-center">
              <CardContent className="pt-6">
                <Star className="h-8 w-8 text-amber-600 mx-auto mb-2" />
                <h3 className="font-semibold text-gray-900">Premium Service</h3>
                <p className="text-sm text-gray-600">Exceptional dining experience</p>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </section>
  );
};

export default HeroSection;
