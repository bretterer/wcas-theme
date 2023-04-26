<?php
/**
 * Plugin Name: Docker Mailhog Development
 * Description: Send all mail to Mailhog during development
 * Plugin URI: https://bretterer.com
 * Author: Brian Retterer
 * Author URI: https://bretterer.com
 * Version: 1.0.0
 * License: GPL2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 */

defined( 'ABSPATH' ) || exit;

class MailHogDev {

    public function __construct() {
        add_action( 'phpmailer_init', array( $this, 'phpmailer_init' ) );

        // wp-includes/pluggable.php
        add_filter( 'wp_mail_from', function($fromEmail) { return 'website@example.com'; } );
    }

    public function phpmailer_init( $phpmailer ) {
        $phpmailer->Mailer = 'smtp';
        $phpmailer->Sender = 'website@example.com';
        $phpmailer->Host = 'mailhog';
        $phpmailer->Port = 1025;

    }

}

$mhd = new MailHogDev();
