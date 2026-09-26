--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with System;

with A0B.Types.Big_Endian;

with ESPIDF.C_Strings;
with ESPIDF.Event;

package ESPIDF.NETIF is

   type esp_netif_t is limited private;
   --  Type of esp_netif_object server.

   type esp_netif_t_ptr is access all esp_netif_t with Convention => C;
   --  Handle to esp-netif instance.

   type esp_netif_dhcp_option_mode_t is
     (ESP_NETIF_OP_START,
      ESP_NETIF_OP_SET,
      ESP_NETIF_OP_GET) with Convention => C;
   --  Mode for DHCP client or DHCP server option functions.
   --  @enum ESP_NETIF_OP_SET Set option
   --  @enum ESP_NETIF_OP_GET Get option

   type esp_netif_dhcp_option_id_t is
     (ESP_NETIF_SUBNET_MASK,
      ESP_NETIF_DOMAIN_NAME_SERVER,
      ESP_NETIF_ROUTER_SOLICITATION_ADDRESS,
      ESP_NETIF_VENDOR_SPECIFIC_INFO,
      ESP_NETIF_REQUESTED_IP_ADDRESS,
      ESP_NETIF_IP_ADDRESS_LEASE_TIME,
      ESP_NETIF_IP_REQUEST_RETRY_TIME,
      ESP_NETIF_VENDOR_CLASS_IDENTIFIER,
      ESP_NETIF_CAPTIVEPORTAL_URI) with Convention => C;
   --  Supported options for DHCP client or DHCP server.
   --  @enum ESP_NETIF_SUBNET_MASK Network mask
   --  @enum ESP_NETIF_DOMAIN_NAME_SERVER Domain name server
   --  @enum ESP_NETIF_ROUTER_SOLICITATION_ADDRESS
   --    Solicitation router address
   --  @enum ESP_NETIF_VENDOR_SPECIFIC_INFO
   --    Vendor Specific Information of a DHCP server
   --  @enum ESP_NETIF_REQUESTED_IP_ADDRESS Request specific IP address
   --  @enum ESP_NETIF_IP_ADDRESS_LEASE_TIME Request IP address lease time
   --  @enum ESP_NETIF_IP_REQUEST_RETRY_TIME
   --    Request IP address retry counter
   --  @enum ESP_NETIF_VENDOR_CLASS_IDENTIFIER
   --    Vendor Class Identifier of a DHCP client
   --  @enum ESP_NETIF_CAPTIVEPORTAL_URI Captive Portal Identification
   for esp_netif_dhcp_option_id_t use
     (ESP_NETIF_SUBNET_MASK                   => 1,
      ESP_NETIF_DOMAIN_NAME_SERVER            => 6,
      ESP_NETIF_ROUTER_SOLICITATION_ADDRESS   => 32,
      ESP_NETIF_VENDOR_SPECIFIC_INFO          => 43,
      ESP_NETIF_REQUESTED_IP_ADDRESS          => 50,
      ESP_NETIF_IP_ADDRESS_LEASE_TIME         => 51,
      ESP_NETIF_IP_REQUEST_RETRY_TIME         => 52,
      ESP_NETIF_VENDOR_CLASS_IDENTIFIER       => 60,
      ESP_NETIF_CAPTIVEPORTAL_URI             => 114);

   type esp_ip4_addr_t is record
      addr : A0B.Types.Big_Endian.Unsigned_32;
   end record with Convention => C;
   --  IPv4 address.
   --  @field addr IPv4 address

   type esp_netif_ip_info_t is record
      ip      : esp_ip4_addr_t;
      netmask : esp_ip4_addr_t;
      gw      : esp_ip4_addr_t;
   end record with Convention => C;
   --  IPV4 IP address information.
   --  @field ip Interface IPV4 address
   --  @field netmask Interface IPV4 netmask
   --  @field gw Interface IPV4 gateway address

   IP_EVENT : constant ESPIDF.Event.esp_event_base_t
     with Import, Convention => C, External_Name => "IP_EVENT";
   --  IP event base declaration.

   IP_EVENT_STA_GOT_IP            : constant int32_t := 0;
   --  Station got IP from connected AP
   IP_EVENT_STA_LOST_IP           : constant int32_t := 1;
   --  Station lost IP and the IP is reset to 0
   IP_EVENT_ASSIGNED_IP_TO_CLIENT : constant int32_t := 2;
   --  DHCP server assigned an IP to a connected client
   IP_EVENT_GOT_IP6               : constant int32_t := 3;
   --  Station or ap or ethernet interface v6IP addr is preferred
   IP_EVENT_ETH_GOT_IP            : constant int32_t := 4;
   --  Ethernet got IP from connected AP
   IP_EVENT_ETH_LOST_IP           : constant int32_t := 5;
   --  Ethernet lost IP and the IP is reset to 0
   IP_EVENT_PPP_GOT_IP            : constant int32_t := 6;
   --  PPP interface got IP
   IP_EVENT_PPP_LOST_IP           : constant int32_t := 7;
   --  PPP interface lost IP
   IP_EVENT_TX_RX                 : constant int32_t := 8;
   --  Transmitting/receiving data packet
   IP_EVENT_NETIF_UP              : constant int32_t := 9;
   --  Unified netif status: interface became up
   IP_EVENT_NETIF_DOWN            : constant int32_t := 10;
   --  Unified netif status: interface went down

   function esp_netif_init return esp_err_t
     with Import, Convention => C, External_Name => "esp_netif_init";
   --  Initialize the underlying TCP/IP stack.
   --
   --  Note: This subprogram should be called exactly once from application
   --  code, when the application starts up.
   --  @return
   --    - `ESP_OK` if TCP/IP stack was initialized successfully
   --    - `ESP_FAIL` if initializing failed

   procedure esp_netif_init;
   --  Initialize the underlying TCP/IP stack.
   --
   --  Note: This subprogram should be called exactly once from application
   --  code, when the application starts up.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_FAIL` if initializing failed

   function esp_netif_get_ip_info
     (netif   : esp_netif_t_ptr;
      ip_info : out esp_netif_ip_info_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_netif_get_ip_info";
   --  Get interface's IP address information.
   --
   --  If the interface is up, IP information is read directly from the
   --  TCP/IP stack. If the interface is down, IP information is read from a
   --  copy kept in the ESP-NETIF instance.
   --  @param netif Handle to esp-netif instance
   --  @param ip_info
   --    If successful, IP information will be returned in this argument.
   --  @return
   --    - `ESP_OK` if IP information was retrieved successfully
   --    - `ESP_ERR_ESP_NETIF_INVALID_PARAMS` if parameters are invalid

   procedure esp_netif_get_ip_info
     (netif   : esp_netif_t_ptr;
      ip_info : out esp_netif_ip_info_t);
   --  Get interface's IP address information.
   --
   --  If the interface is up, IP information is read directly from the
   --  TCP/IP stack. If the interface is down, IP information is read from a
   --  copy kept in the ESP-NETIF instance.
   --  @param netif Handle to esp-netif instance
   --  @param ip_info
   --    If successful, IP information will be returned in this argument.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_ESP_NETIF_INVALID_PARAMS` if parameters are invalid

   function esp_netif_dhcps_option
     (esp_netif : esp_netif_t_ptr;
      opt_op    : esp_netif_dhcp_option_mode_t;
      opt_id    : esp_netif_dhcp_option_id_t;
      opt_val   : System.Address;
      opt_len   : uint32_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_netif_dhcps_option";
   --  Set or Get DHCP server option.
   --
   --  Note: Please note that not all combinations of identifiers and options
   --  are supported.
   --
   --  Get operations:
   --    - `ESP_NETIF_IP_ADDRESS_LEASE_TIME`
   --    - `ESP_NETIF_SUBNET_MASK`/`ESP_NETIF_REQUESTED_IP_ADDRESS` (both
   --      options do the same, they reflect `dhcps_lease_t`)
   --    - `ESP_NETIF_ROUTER_SOLICITATION_ADDRESS`
   --    - `ESP_NETIF_DOMAIN_NAME_SERVER`
   --
   --  Set operations:
   --    - `ESP_NETIF_IP_ADDRESS_LEASE_TIME`
   --    - `ESP_NETIF_SUBNET_MASK` -- set operation is allowed only if the
   --      configured mask corresponds to the settings, if not, please use
   --      `esp_netif_set_ip_info` to prevent misconfiguration of DHCPS.
   --    - `ESP_NETIF_REQUESTED_IP_ADDRESS` -- if the address pool is enabled,
   --      a sanity check for start/end addresses is performed before
   --      setting.
   --    - `ESP_NETIF_ROUTER_SOLICITATION_ADDRESS`
   --    - `ESP_NETIF_DOMAIN_NAME_SERVER`
   --    - `ESP_NETIF_CAPTIVEPORTAL_URI` -- set operation copies the pointer
   --      to the URI, so it is owned by the application and needs to be
   --      maintained valid throughout the entire DHCP Server lifetime.
   --  @param esp_netif Handle to esp-netif instance
   --  @param opt_op
   --    `ESP_NETIF_OP_SET` to set an option, `ESP_NETIF_OP_GET` to get an
   --    option.
   --  @param opt_id
   --    Option index to get or set, must be one of the supported enum
   --    values.
   --  @param opt_val Address of the option parameter.
   --  @param opt_len Length of the option parameter.
   --  @return
   --    - `ESP_OK` if option was set or retrieved successfully
   --    - `ESP_ERR_ESP_NETIF_INVALID_PARAMS` if parameters are invalid
   --    - `ESP_ERR_ESP_NETIF_DHCP_ALREADY_STOPPED` if DHCP server is already
   --      stopped
   --    - `ESP_ERR_ESP_NETIF_DHCP_ALREADY_STARTED` if DHCP server is already
   --      started

   procedure esp_netif_dhcps_option
     (esp_netif : esp_netif_t_ptr;
      opt_op    : esp_netif_dhcp_option_mode_t;
      opt_id    : esp_netif_dhcp_option_id_t;
      opt_val   : System.Address;
      opt_len   : uint32_t);
   --  Set or Get DHCP server option.
   --
   --  Note: Please note that not all combinations of identifiers and options
   --  are supported.
   --
   --  Get operations:
   --    - `ESP_NETIF_IP_ADDRESS_LEASE_TIME`
   --    - `ESP_NETIF_SUBNET_MASK`/`ESP_NETIF_REQUESTED_IP_ADDRESS` (both
   --      options do the same, they reflect `dhcps_lease_t`)
   --    - `ESP_NETIF_ROUTER_SOLICITATION_ADDRESS`
   --    - `ESP_NETIF_DOMAIN_NAME_SERVER`
   --
   --  Set operations:
   --    - `ESP_NETIF_IP_ADDRESS_LEASE_TIME`
   --    - `ESP_NETIF_SUBNET_MASK` -- set operation is allowed only if the
   --      configured mask corresponds to the settings, if not, please use
   --      `esp_netif_set_ip_info` to prevent misconfiguration of DHCPS.
   --    - `ESP_NETIF_REQUESTED_IP_ADDRESS` -- if the address pool is enabled,
   --      a sanity check for start/end addresses is performed before
   --      setting.
   --    - `ESP_NETIF_ROUTER_SOLICITATION_ADDRESS`
   --    - `ESP_NETIF_DOMAIN_NAME_SERVER`
   --    - `ESP_NETIF_CAPTIVEPORTAL_URI` -- set operation copies the pointer
   --      to the URI, so it is owned by the application and needs to be
   --      maintained valid throughout the entire DHCP Server lifetime.
   --  @param esp_netif Handle to esp-netif instance
   --  @param opt_op
   --    `ESP_NETIF_OP_SET` to set an option, `ESP_NETIF_OP_GET` to get an
   --    option.
   --  @param opt_id
   --    Option index to get or set, must be one of the supported enum
   --    values.
   --  @param opt_val Address of the option parameter.
   --  @param opt_len Length of the option parameter.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_ESP_NETIF_INVALID_PARAMS` if parameters are invalid
   --    - `ESP_ERR_ESP_NETIF_DHCP_ALREADY_STOPPED` if DHCP server is already
   --      stopped
   --    - `ESP_ERR_ESP_NETIF_DHCP_ALREADY_STARTED` if DHCP server is already
   --      started

   function esp_netif_dhcps_option_SET_CAPTIVEPORTAL_URI
     (esp_netif : esp_netif_t_ptr;
      opt_val   : ESPIDF.C_Strings.const_char_ptr) return esp_err_t;
   --  Set DHCP server captive portal URI option
   --  (`ESP_NETIF_CAPTIVEPORTAL_URI`).
   --
   --  Set operation copies the pointer to the URI, so it is owned by the
   --  application and needs to be maintained valid throughout the entire
   --  DHCP Server lifetime.
   --  @param esp_netif Handle to esp-netif instance
   --  @param opt_val Captive portal URI.
   --  @return
   --    - `ESP_OK` if option was set successfully
   --    - `ESP_ERR_ESP_NETIF_INVALID_PARAMS` if parameters are invalid
   --    - `ESP_ERR_ESP_NETIF_DHCP_ALREADY_STOPPED` if DHCP server is already
   --      stopped
   --    - `ESP_ERR_ESP_NETIF_DHCP_ALREADY_STARTED` if DHCP server is already
   --      started

   procedure esp_netif_dhcps_option_SET_CAPTIVEPORTAL_URI
     (esp_netif : esp_netif_t_ptr;
      opt_val   : ESPIDF.C_Strings.const_char_ptr);
   --  Set DHCP server captive portal URI option
   --  (`ESP_NETIF_CAPTIVEPORTAL_URI`).
   --
   --  Set operation copies the pointer to the URI, so it is owned by the
   --  application and needs to be maintained valid throughout the entire
   --  DHCP Server lifetime.
   --  @param esp_netif Handle to esp-netif instance
   --  @param opt_val Captive portal URI.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_ESP_NETIF_INVALID_PARAMS` if parameters are invalid
   --    - `ESP_ERR_ESP_NETIF_DHCP_ALREADY_STOPPED` if DHCP server is already
   --      stopped
   --    - `ESP_ERR_ESP_NETIF_DHCP_ALREADY_STARTED` if DHCP server is already
   --      started

private

   type esp_netif_t is limited null record with Convention => C;
   --  Full declaration of this type is not visible via "esp_netif.h"

end ESPIDF.NETIF;
