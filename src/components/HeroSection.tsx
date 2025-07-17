import React from 'react';
import { Button } from '@/components/ui/button';

interface HeroSectionProps {
  onBookTable: () => void;
}

const HeroSection: React.FC<HeroSectionProps> = ({ onBookTable }) => {
  return (
    <section
      className="relative h-screen w-full flex items-center justify-start"
      style={{
        backgroundImage: `url('https://tablepilot.co.uk/woodmanandolive/images/woodmanandolive_001.jpeg')`,
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        backgroundRepeat: 'no-repeat',
      }}
    >
      <div className="absolute inset-0 bg-black/30" aria-hidden="true"></div>
      <div className="max-w-7xl mx-auto px-8 sm:px-12 lg:px-16 relative z-10 w-full">
        <div className="text-left max-w-2xl">
          <h1 className="text-5xl md:text-6xl font-light mb-4 text-white">
            Welcome to
            <br />
            <span className="font-medium">The Woodman & Olive</span>
          </h1>
          
          <div className="mt-12">
            <Button 
              onClick={onBookTable}
              variant="outline"
              size="lg" 
              className="bg-black/20 hover:bg-black/40 border-white text-white px-8 py-2 text-lg font-light tracking-wide transition-all"
            >
              OUR MENUS
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
};

export default HeroSection;
