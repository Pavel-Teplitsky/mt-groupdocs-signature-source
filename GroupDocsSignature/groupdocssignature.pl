#!/usr/bin/perl

package MT::Plugin::GroupDocsSignature;

use strict;
use warnings;
use MT 4.0;
use base qw( MT::Plugin );

our $DISPLAY_NAME = 'GroupDocs Signature via BBCode'; 
our $VERSION = '1.00';

our ($plugin, $PLUGIN_MODULE, $PLUGIN_KEY);
MT->add_plugin($plugin = __PACKAGE__->new({
   id          => plugin_module(),
   key         => plugin_key(),
   name        => plugin_name(),
   description => "A text filter to use BBCode-like tag to include GroupDocs Signature. You can embed a GroupDocs file for viewing with this BBCode<p><pre>[gds width=500 height=600]1223456789[/gds]</pre></p>",
   version     => $VERSION,
   author_name => "Marketplace Team",
   author_link => "http://www.groupdocs.com",
   plugin_link => "https://github.com/groupdocs/mt-groupdocs-signature-source",
   doc_link		 => "http://www.groupdocs.com"
}));

MT->add_text_filter(groupdocs_signature => { label => 'GroupDocs Signature', on_format => sub { &gdsformat }, });

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
    });
}

sub gdsformat {
	my $s = shift;
	gdsfullcode($s);
}

sub gdsfullcode {
    my $s = $_[0];
    $s = &gdsignature($s);

    $s = gdsmaincode($s);
    return $s;
}

sub commentcode {
    my $s = $_[0];

    $s =~ s!<!\*amp;lt;!g;
    $s =~ s!>!\*amp;gt;!g;
    $s = gdsmaincode($s);
    $s =~ s!\*amp;!&!g;

    return $s;
}
sub gdsmaincode {
    my $s = $_[0];

    $s =~ s!�!�!g;
    $s =~ s!�!�!g;
    $s =~ s!�!�!g;
    $s =~ s!�!�!g;
    $s =~ s!�!�!g;
    $s =~ s!�!�!g;
    $s =~ s!�!�!g;

    $s = MT::Util::html_text_transform($_[0]);
    $s =~ s!(<p>.*?</p>)!vsmarty_pnts($1)!geis;
    $s =~ s!<linebreak>!\n!g;

    return $s;
}

sub vsmarty_pnts {
    my $s = $_[0];
    my $smarty = $MT::Template::Context::Global_filters{'smarty_pants'};
		return $smarty ? $smarty->($s, '1') : $s;
}

sub gdsignature {
	my $er	= sub() {
		my ($id,$height,$width,$hq) = (shift,shift,shift,shift);
		return <<""
			<h2>
                <iframe src="https://apps.groupdocs.com/signature2/forms/SignEmbed/$id?quality=50&use_pdf=False&download=False&referer=mt-Signature/1.0.0" frameborder="0" width="$width" height="$height">
					If you can see this text, your browser does not support iframes. Please enable iframe support in your browser or use the latest version of any popular web browser such as Mozilla Firefox or Google Chrome. For more help, please check our documentation Wiki: http://groupdocs.com/docs/display/signature/GroupDocs+Signature+Integration+with+3rd+Party+Platforms
				</iframe>
            </h2>
            
	};
	return &_def_filter(shift, 'gds', $er, 350, 425);
}

sub _def_filter {
	my ($s,$tag,$er,$defH,$defW) = @_;

	my $re	= '\[' . $tag. '\s*(.*?)](.*?)\[\/' . $tag. ']';

	$s =~ s{$re}{
		my $params		= $1;
		my $v					= $2;
		my $height		= ($params =~ /height\s*=\s*"?(\d+)"?/) ? $1 : $defH;
		my $width			= ($params =~ /width\s*=\s*"?(\d+)"?/) ? $1 : $defW;
        my $signature			= ($params =~ /signature\s*=\s*"?(\d+)"?/) ? $1 : "";
		$er->($v,$height,$width, $signature);
	}gse;

	return $s;
}

#system sub plugin_name
sub plugin_name     { return ($DISPLAY_NAME || plugin_module()) }

#system sub plugin_module
sub plugin_module   {
    $PLUGIN_MODULE or ($PLUGIN_MODULE = __PACKAGE__) =~ s/^MT::Plugin:://;
    return $PLUGIN_MODULE;
}

#system sub plugin_key
sub plugin_key      {
    $PLUGIN_KEY or ($PLUGIN_KEY = lc(plugin_module())) =~ s/\s+//g;
    return $PLUGIN_KEY
}

1;

__END__

=pod

=head1 NAME

B<GroupDocsSignature>  - A text filter to use BBCode-like tag to include GroupDocs Signature.

=head1 SYNOPSIS

To include GroupDocs Signature with  file id: 1223456789

 [gds]1223456789[/gds]

To include GroupDocs Signature with  file id: 1223456789 and with widht and height

 [gds width=500 height=600]1223456789[/gds]

=head1 HOW TO INSTALL 

=over 4

=item 1. Download the zip or tar.gz file and upload the contents of the 'plugins' folder to the 'plugins' directory of your MT installation. 

=back


=head1 USAGE

=over 4

=item 1. Write a new blog entry.

=item 2. In "Format" combo, switch format to "GroupDocs Signature"

=item 3. Append your file from GroupDocs account as [gds]1223456789[/gds]

=item 4. Optional you can continue to edit your page in "Rich Text" mode. The "gds" tag will be substituted with embedded code.

=item 5. Save and view page.

=back


=head1 VERSION HISTORY

=over 4

=item * 1.00 (2012)

Created by Marketplace Team;

=back

=head1 AUTHOR

Marketplace Team <http://www.groupdocs.com>

Original code: Crys Clouse <http://forums.sixapart.com/index.php?showtopic=59263>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2012 - Marketplace Team <http://www.groupdocs.com/>

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    To received a copy of the GNU General Public License
    see <http://www.gnu.org/licenses/>.


=cut
