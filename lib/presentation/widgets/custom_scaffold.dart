import 'package:flutter/material.dart';
import '../../config/constants.dart';
import 'responsive_layout.dart';

/// A custom scaffold that provides consistent UI with responsive design
class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? bottom;
  final bool isScrollable;
  final Widget? drawer;
  final Widget? leadingIcon;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? appBarColor;
  final EdgeInsets contentPadding;
  final Widget? bottomSheet;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.bottom,
    this.isScrollable = true,
    this.drawer,
    this.leadingIcon,
    this.onBackPressed,
    this.centerTitle = true,
    this.backgroundColor,
    this.appBarColor,
    this.contentPadding = const EdgeInsets.all(16),
    this.bottomSheet,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= AppConstants.tabletMinWidth;
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title),
        centerTitle: centerTitle,
        backgroundColor: appBarColor,
        elevation: 2,
        leading: leadingIcon ?? (onBackPressed != null 
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onBackPressed,
            )
          : null),
        actions: actions,
        bottom: bottom,
      ),
      drawer: drawer,
      body: _buildBody(context, isTablet),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
    );
  }
  
  Widget _buildBody(BuildContext context, bool isTablet) {
    final content = Padding(
      padding: contentPadding,
      child: isScrollable
          ? SingleChildScrollView(
              child: body,
            )
          : body,
    );
    
    // For tablet and desktop, constrain the width and add extra padding
    if (isTablet) {
      return ResponsiveLayout.contentConstraints(
        context,
        content,
      );
    }
    
    return content;
  }
}

/// A two-panel layout for tablet and desktop displays
class TwoPanelScaffold extends StatelessWidget {
  final String title;
  final Widget leftPanel;
  final Widget rightPanel;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final double leftPanelWidthFraction;
  final bool isLeftPanelScrollable;
  final bool isRightPanelScrollable;
  final EdgeInsets leftPanelPadding;
  final EdgeInsets rightPanelPadding;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;

  const TwoPanelScaffold({
    Key? key,
    required this.title,
    required this.leftPanel,
    required this.rightPanel,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.leftPanelWidthFraction = 0.33,
    this.isLeftPanelScrollable = true,
    this.isRightPanelScrollable = true,
    this.leftPanelPadding = const EdgeInsets.all(16),
    this.rightPanelPadding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= AppConstants.tabletMinWidth;
    
    // On mobile, revert to a regular scaffold with a drawer
    if (!isTablet) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: onBackPressed != null 
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: onBackPressed,
              )
            : null,
          actions: actions,
        ),
        drawer: Drawer(
          child: _buildLeftPanel(context),
        ),
        body: _buildRightPanel(context),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      );
    }
    
    // On tablet and desktop, use a two-panel layout
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: onBackPressed != null 
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onBackPressed,
            )
          : null,
        actions: actions,
      ),
      body: Row(
        children: [
          // Left panel
          SizedBox(
            width: screenSize.width * leftPanelWidthFraction,
            child: _buildLeftPanel(context),
          ),
          
          // Divider
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),
          
          // Right panel
          Expanded(
            child: _buildRightPanel(context),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor,
    );
  }
  
  Widget _buildLeftPanel(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: isLeftPanelScrollable 
        ? SingleChildScrollView(
            child: Padding(
              padding: leftPanelPadding,
              child: leftPanel,
            ),
          )
        : Padding(
            padding: leftPanelPadding,
            child: leftPanel,
          ),
    );
  }
  
  Widget _buildRightPanel(BuildContext context) {
    return isRightPanelScrollable 
      ? SingleChildScrollView(
          child: Padding(
            padding: rightPanelPadding,
            child: rightPanel,
          ),
        )
      : Padding(
          padding: rightPanelPadding,
          child: rightPanel,
        );
  }
}

/// A custom app bar with animated elevation on scroll
class ScrollAwareAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final ScrollController scrollController;
  final double elevation;
  final double elevationWhenScrolled;

  const ScrollAwareAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.bottom,
    this.backgroundColor,
    required this.scrollController,
    this.elevation = 0,
    this.elevationWhenScrolled = 4,
  }) : super(key: key);

  @override
  _ScrollAwareAppBarState createState() => _ScrollAwareAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

class _ScrollAwareAppBarState extends State<ScrollAwareAppBar> {
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final newIsScrolled = widget.scrollController.position.pixels > 0;
    if (newIsScrolled != _isScrolled) {
      setState(() {
        _isScrolled = newIsScrolled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: widget.actions,
      leading: widget.leading,
      centerTitle: widget.centerTitle,
      bottom: widget.bottom,
      backgroundColor: widget.backgroundColor,
      elevation: _isScrolled ? widget.elevationWhenScrolled : widget.elevation,
    );
  }
}