import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final Widget title;
  final Function(String)? onSearch;
  const Search({Key? key, required this.title, this.onSearch}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  bool _showSearch = false;
  late final TextEditingController _searchController;
  late final AnimationController _animationController;
  final FocusNode _focusNode = FocusNode();
  final _duration = Duration(milliseconds: 250);

  @override
  void initState() {
    _searchController = TextEditingController();
    _animationController = AnimationController(vsync: this, duration: _duration);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _focusNode.requestFocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedSwitcher(
              duration: _duration,
              child: _showSearch
                  ? AnimatedBuilder(
                      animation: _animationController,
                      builder: (BuildContext context, Widget? child) => FractionallySizedBox(
                        widthFactor: _animationController.value,
                        child: child,
                      ),
                      child: TextFormField(
                        key: ValueKey("help"),
                        controller: _searchController,
                        focusNode: _focusNode,
                        autofocus: false,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                        cursorWidth: 2,
                        onChanged: (query) => widget.onSearch != null ? widget.onSearch!(query) : null,
                        decoration: InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).textTheme.bodyLarge!.color!)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).textTheme.bodyLarge!.color!)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).textTheme.bodyLarge!.color!)),
                          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        ),
                      ),
                    )
                  : Center(child: widget.title),
            ),
          ],
        )),
        if (widget.onSearch != null)
          IconButton(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.comfortable,
            constraints: const BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            icon: AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget? child) => RotationTransition(
                turns: _animationController,
                child: AnimatedSwitcher(
                    duration: _duration,
                    child: _showSearch ? Icon(Icons.close, key: ValueKey(0)) : Icon(Icons.search, key: ValueKey(1))),
              ),
            ),
            onPressed: () => setState(() {
              _showSearch = !_showSearch;
              if (_showSearch) {
                _searchController.text = "";
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
              if (widget.onSearch != null) widget.onSearch!("");
            }),
          ),
      ],
    );
  }
  /*

                AnimatedSwitcher(
                key: ValueKey(1),
                duration: Duration(milliseconds: 8000),
                switchInCurve: Curves.easeInOut,
                child: Center(
                  child: _searchActive
                      ?
                      :
                ),
              ),
   */
}
