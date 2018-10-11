package Plugins::Crawler::emailColect;

use Uniscan::Functions;

	my $func = Uniscan::Functions->new();

sub new {
    my $class    = shift;
    my $self     = {name => "E-mail Detection", version => 1.0};
	our %email : shared = ();
	our $enabled = 1;
    return bless $self, $class;
}

sub execute {
    my $self = shift;
	my $url = shift;
	my $content = shift;

	while($content =~m/([\w\-\_\.]+\@[\w\d\-]+\.\w+[\.[a-z]+]*)/g){
		$email{$1}++ if defined $1 && isValidEmail($1);
	}
}

sub isValidEmail{
	my $email = shift;
  return $email !~ /\.text|\.label|\.css|\.jpg|\.jpeg|\.png|\.ico|\.mp4|\.mp3|\.json|\.xml|\.doc|\.pdf|\.js|mailto:/gi ? 1 : 0;

}

sub showResults(){
	my $self = shift;
	$func->write("|\n| E-mails:");
	foreach my $mail (%email){
		$func->write("| [+] E-mail Found: ". $mail . " " . $email{$mail} . "x times") if($email{$mail});
	}
}

sub getResults(){
	my $self = shift;
	return %email;
}

sub clean(){
	my $self = shift;
	%email = ();
}


sub status(){
	my $self = shift;
	return $enabled;
}

1;
